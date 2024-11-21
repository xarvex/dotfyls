{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.brightnessctl;
in
{
  options.dotfyls.programs.brightnessctl = {
    enable = lib.mkEnableOption "brightnessctl" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "brightnessctl" { };
  };

  config = lib.mkIf cfg.enable { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
