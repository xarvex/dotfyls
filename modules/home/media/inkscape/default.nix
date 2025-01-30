{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.inkscape;
in
{
  options.dotfyls.media.inkscape = {
    enable = lib.mkEnableOption "Inkscape" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Inkscape" { default = "inkscape"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
