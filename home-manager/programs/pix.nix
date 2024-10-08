{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.pix;
in
{
  options.dotfyls.programs.pix = {
    enable = lib.mkEnableOption "Pix" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Pix" { default = "pix"; };
  };

  config = lib.mkIf cfg.enable { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
