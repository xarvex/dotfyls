{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.media;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "media"
        "mpris2"
        "playerctl"
        "daemon"
      ]
      [
        "services"
        "playerctld"
      ]
    )
  ];

  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // {
      default = config.dotfyls.desktops.enable;
    };
    audio.enable = lib.mkEnableOption "audio" // {
      default = true;
    };
    wireplumber = {
      enable = lib.mkEnableOption "WirePlumber" // {
        default = true;
      };
      package = lib.mkPackageOption pkgs "WirePlumber" { default = "wireplumber"; };
    };
    mpris2 = {
      proxy.enable = lib.mkEnableOption "MPRIS2 proxy" // {
        default = config.dotfyls.desktops.enable;
      };
      playerctl = {
        enable = lib.mkEnableOption "playerctl" // {
          default = config.dotfyls.desktops.enable;
        };
        package = lib.mkPackageOption pkgs "playerctl" { };
        daemon.enable = lib.mkEnableOption "playerctld" // {
          default = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.persist.cacheDirectories = lib.optional cfg.wireplumber.enable ".local/state/wireplumber";

        services.mpris-proxy.enable = lib.mkIf cfg.mpris2.proxy.enable true;
      }

      (lib.mkIf cfg.mpris2.playerctl.enable {
        home.packages = [ (self.lib.getCfgPkg cfg.mpris2.playerctl) ];

        services.playerctld.enable = lib.mkIf cfg.mpris2.playerctl.daemon.enable true;
      })
    ]
  );
}
