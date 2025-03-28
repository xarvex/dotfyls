{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.pipewire;
  hmCfg = config.hm.dotfyls.media.pipewire;
in
{
  options.dotfyls.media.pipewire = {
    enable = lib.mkEnableOption "PipeWire" // {
      default = hmCfg.enable;
    };
    audio.enable = lib.mkEnableOption "PipeWire audio" // {
      default = hmCfg.audio.enable;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.pipewire =
      {
        enable = true;
      }
      // lib.optionalAttrs cfg.audio.enable {
        wireplumber.enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
  };
}
