{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.inkscape;
in
{
  options.dotfyls.media.inkscape.enable = lib.mkEnableOption "Inkscape" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = with pkgs; [ inkscape ]; };
}
