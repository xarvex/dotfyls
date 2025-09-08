{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.obs;
in
{
  options.dotfyls.media.obs.enable = lib.mkEnableOption "Open Broadcaster Software" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { programs.obs-studio.enable = true; };
}
