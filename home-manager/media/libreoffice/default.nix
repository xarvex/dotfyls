{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.libreoffice;
in
{
  options.dotfyls.media.libreoffice = {
    enable = lib.mkEnableOption "LibreOffice" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "LibreOffice" { default = "libreoffice"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".config/libreoffice" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
