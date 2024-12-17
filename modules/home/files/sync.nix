{
  config,
  lib,
  self,
  user,
  ...
}:

let
  cfg = config.dotfyls.files.sync;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "files" "sync" ] [ "services" "syncthing" ])
  ];

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
        }) (lib.filterAttrs (_: fCfg: fCfg.dir && fCfg.sync.enable) config.dotfyls.file);
      };
    };
  };
}
