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
    dotfyls.files.".local/state/wireplumber" = lib.mkIf cfg.audio.enable {
      mode = "0700";
      cache = true;
    };
  };
}
