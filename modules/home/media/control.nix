{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.foliate;
in
{
  options.dotfyls.media.control.enable = lib.mkEnableOption "PulseAudio Volume Control" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = with pkgs; [ pavucontrol ]; };
}
