{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  cfg = config.dotfyls.files.sync;

  syncedFiles = lib.filterAttrs (_: fCfg: fCfg.dir && fCfg.sync.enable) config.dotfyls.file;
in
{
  options.dotfyls.files.sync.enable = lib.mkEnableOption "sync using Syncthing" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".local/state/syncthing" = {
      mode = "0700";
      cache = true;
    };

    home.sessionVariables.STNODEFAULTFOLDER = "true";

    services.syncthing = {
      enable = true;

      overrideDevices = false;
      settings = {
        gui = {
          theme = "black";
          tls = true;
          inherit user;
        };
        options = {
          urAccepted = -1;
          crashReportingEnabled = false;
          startBrowser = false;
        };
        folders = builtins.mapAttrs (_: fCfg: {
          inherit (fCfg) path;
          rescanIntervalS = fCfg.sync.rescan;
          fsWatcherEnabled = fCfg.sync.watch.enable;
          fsWatcherDelayS = fCfg.sync.watch.delay;
          inherit (fCfg.sync) order;
        }) syncedFiles;
      };
    };

    systemd.user.services.dotfyls-syncthing-folder-share =
      let
        folderShare = pkgs.writeShellApplication {
          name = "dotfyls-syncthing-folder-share";

          runtimeInputs = [ config.services.syncthing.package ];

          text = ''
            while read -r device; do
            ${builtins.concatStringsSep "\n" (
              lib.mapAttrsToList (
                file: _: "    ${''syncthing cli config folders "${file}" devices add --device-id "''${device}"''}"
              ) syncedFiles
            )}
            done <<EOF
            $(syncthing cli config devices list)
            EOF
          '';
        };
      in
      {
        Unit = {
          Description = "dotfyls - Syncthing Folder Share";
          After = [ "syncthing.service" ];
          Wants = [ "syncthing.service" ];
          PartOf = [ "syncthing.service" ];
        };

        Service = {
          Type = "oneshot";
          ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
          ExecStart = lib.getExe folderShare;
          Restart = "on-failure";
          RestartSec = "4";
        };

        Install.WantedBy = [ "syncthing.service" ];
      };
  };
}
