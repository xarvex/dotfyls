{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.files.sync;

  syncedFiles = lib.filterAttrs (_: fCfg: fCfg.dir && fCfg.sync.enable) config.dotfyls.file;

  folderShare = pkgs.writers.writeDash "dotfyls-syncthing-folder-share" ''
    while read -r device; do
    ${lib.concatMapAttrsStringSep "\n" (
      file: _:
      "    ${
            ''${self.lib.getCfgExe config.services.syncthing} cli config folders "${file}" devices add --device-id "''${device}"''
          }"
    ) syncedFiles}
    done <<EOF
    $(${self.lib.getCfgExe config.services.syncthing} cli config devices list)
    EOF
  '';
in
{
  options.dotfyls.files.sync.enable = lib.mkEnableOption "sync using Syncthing" // {
    default = !config.dotfyls.meta.machine.isVirtual;
  };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      meta.location = "${config.xdg.userDirs.documents}/Projects/dotfyls";

      file.".local/state/syncthing" = {
        mode = "0700";
        cache = true;
      };
    };

    home.sessionVariables.STNODEFAULTFOLDER = lib.boolToString true;

    services.syncthing = {
      enable = true;

      overrideDevices = false;
      settings = {
        gui = {
          theme = "black";
          tls = true;
          inherit (config.dotfyls.meta) user;
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

    systemd.user.services.dotfyls-syncthing-folder-share = {
      Unit = {
        Description = "dotfyls - Syncthing Folder Share";
        After = [ "syncthing.service" ];
        Wants = [ "syncthing.service" ];
        PartOf = [ "syncthing.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 1";
        ExecStart = folderShare;
        Restart = "on-failure";
        RestartSec = 4;
      };

      Install.WantedBy = [ "syncthing.service" ];
    };
  };
}
