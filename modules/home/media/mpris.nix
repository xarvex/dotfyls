{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.mpris;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "media"
        "mpris"
        "playerctl"
      ]
      [
        "services"
        "playerctld"
      ]
    )
  ];

  options.dotfyls.media.mpris = {
    enable = lib.mkEnableOption "MPRIS2" // {
      default = config.dotfyls.desktops.enable;
    };
    proxy.enable = lib.mkEnableOption "MPRIS2 proxy" // {
      default = true;
    };
    playerctl = {
      enable = lib.mkEnableOption "playerctl" // {
        default = true;
      };
      daemon.enable = lib.mkEnableOption "playerctld" // {
        default = true;
      };
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) (
    lib.mkMerge [
      (lib.mkIf cfg.proxy.enable { services.mpris-proxy.enable = true; })

      (lib.mkIf cfg.playerctl.enable {
        home.packages = [ (self.lib.getCfgPkg cfg.playerctl) ];

        services.playerctld.enable = lib.mkIf cfg.playerctl.daemon.enable true;
      })
    ]
  );
}
