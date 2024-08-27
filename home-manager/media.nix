{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.media;
in
{
  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // { default = config.dotfyls.desktops.enable; };
    audio.enable = lib.mkEnableOption "audo" // { default = true; };
    wireplumber = {
      enable = lib.mkEnableOption "WirePlumber" // { default = true; };
      package = lib.mkPackageOption pkgs "WirePlumber" { default = "wireplumber"; };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.wireplumber.enable) {
    dotfyls.persist.cacheDirectories = [ ".local/state/wireplumber" ];
  };
}
