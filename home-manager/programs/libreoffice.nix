{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.libreoffice;
in
{
  options.dotfyls.programs.libreoffice = {
    enable = lib.mkEnableOption "LibreOffice" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "LibreOffice" { default = "libreoffice"; };
  };

  config = lib.mkIf cfg.enable { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
