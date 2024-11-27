{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.swww;
in
{
  options.dotfyls.programs.swww = {
    enable = lib.mkEnableOption "swww" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "swww" { };
  };

  config = lib.mkIf cfg.enable { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
