{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.media;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "media" "mpris2" "playerctl" "daemon" ]
      [ "services" "playerctld" ])
  ];

  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // { default = config.dotfyls.desktops.enable; };
    audio.enable = lib.mkEnableOption "audo" // { default = true; };
    wireplumber = {
      enable = lib.mkEnableOption "WirePlumber" // { default = true; };
      package = lib.mkPackageOption pkgs "WirePlumber" { default = "wireplumber"; };
    };
    mpris2 = {
      proxy.enable = lib.mkEnableOption "MPRIS2 proxy" // { default = config.dotfyls.desktops.enable; };
      playerctl = {
        enable = lib.mkEnableOption "playerctl" // { default = config.dotfyls.desktops.enable; };
        package = lib.mkPackageOption pkgs "playerctl" { };
        daemon.enable = lib.mkEnableOption "playerctld" // { default = true; };
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.wireplumber.enable {
      dotfyls.persist.cacheDirectories = [ ".local/state/wireplumber" ];
    })

    (lib.mkIf cfg.mpris2.proxy.enable {
      services.mpris-proxy.enable = true;
    })
    (lib.mkIf cfg.mpris2.playerctl.enable (lib.mkMerge [
      {
        home.packages = [ (self.lib.getCfgPkg cfg.mpris2.playerctl) ];
      }
      (lib.mkIf cfg.mpris2.playerctl.daemon.enable {
        services.playerctld.enable = true;
      })
    ]))
  ]);
}
