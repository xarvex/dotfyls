{ config, lib, ... }:

let
  cfg = config.dotfyls.media;
in
{
  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // { default = config.dotfyls.desktops.enable; };
    audio.enable = lib.mkEnableOption "audo" // { default = true; };
  };

  config = lib.mkIf (cfg.enable && cfg.audio.enable) {
    dotfyls.persist.cacheDirectories = [ ".local/state/wireplumber" ];
  };
}
