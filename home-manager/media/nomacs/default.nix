{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.media.nomacs;
in
{
  options.dotfyls.media.nomacs = {
    enable = lib.mkEnableOption "nomacs" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "nomacs" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile."nomacs/Image Lounge.conf".source = ./${"Image Lounge.conf"};
  };
}
