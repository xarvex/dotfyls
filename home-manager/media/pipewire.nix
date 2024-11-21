{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.pipewire;
in
{
  options.dotfyls.media.pipewire = {
    enable = lib.mkEnableOption "PipeWire" // {
      default = config.dotfyls.desktops.enable;
    };
    audio = {
      enable = lib.mkEnableOption "PipeWire audio" // {
        default = true;
      };
      wireplumber.package = lib.mkPackageOption pkgs "WirePlumber" { default = "wireplumber"; };
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = lib.optional cfg.audio.enable ".local/state/wireplumber";
  };
}
