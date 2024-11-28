{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.pipewire;
in
{
  options.dotfyls.media.pipewire = {
    enable = lib.mkEnableOption "PipeWire" // {
      default = config.dotfyls.desktops.enable;
    };
    audio.enable = lib.mkEnableOption "PipeWire audio" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.files.cacheDirectories = lib.optional cfg.audio.enable ".local/state/wireplumber";
  };
}
