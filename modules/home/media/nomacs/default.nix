{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.nomacs;
in
{
  options.dotfyls.media.nomacs = {
    enable = lib.mkEnableOption "nomacs" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "nomacs" { default = "nomacs-qt6"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile."nomacs/Image Lounge.conf".source = ./${"Image Lounge.conf"};
  };
}
