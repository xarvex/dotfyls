{ config, lib, self, ... }:

let
  cfg = config.dotfyls.media;
  hmCfg = config.hm.dotfyls.media;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "media" "wireplumber" ]
      [ "services" "pipewire" "wireplumber" ])
  ];

  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // { default = hmCfg.enable; };
    audio.enable = lib.mkEnableOption "audo" // { default = hmCfg.audio.enable; };
    wireplumber.enable = lib.mkEnableOption "WirePlumber" // { default = hmCfg.wireplumber.enable; };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      audio = { inherit (cfg.audio) enable; };
      wireplumber = { inherit (cfg.wireplumber) enable; };
    }
    // lib.optionalAttrs cfg.audio.enable {
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
