{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.pipewire;
in
{
  options.dotfyls.media.pipewire.enable = lib.mkEnableOption "PipeWire" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;

      wireplumber.enable = true;
    };
  };
}
