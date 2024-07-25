{ config, lib, ... }:

let
  cfg = config.dotfyls.media;
  hmCfg = config.hm.dotfyls.media;
in
{
  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // { default = hmCfg.enable; };
    audio.enable = lib.mkEnableOption "audo" // { default = hmCfg.audio.enable; };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      audio = { inherit (cfg.audio) enable; };
    } // lib.optionalAttrs cfg.audio.enable {
      wireplumber.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
