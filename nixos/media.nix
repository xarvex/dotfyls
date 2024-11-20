{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.media;
  hmCfg = config.hm.dotfyls.media;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "media"
        "wireplumber"
      ]
      [
        "services"
        "pipewire"
        "wireplumber"
      ]
    )
  ];

  options.dotfyls.media = {
    enable = lib.mkEnableOption "media" // {
      default = hmCfg.enable;
    };
    audio.enable = lib.mkEnableOption "audio" // {
      default = hmCfg.audio.enable;
    };
    wireplumber.enable = lib.mkEnableOption "WirePlumber" // {
      default = hmCfg.wireplumber.enable;
    };
  };

  config = lib.mkIf cfg.enable {
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
