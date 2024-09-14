# TODO: make own version
{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.sl;
in
{
  options.dotfyls.programs.sl = {
    enable = lib.mkEnableOption "Steam Locomotive" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "Steam Locomotive" { default = "sl"; };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ (self.lib.getCfgPkg cfg) ];

      shellAliases.sl = "sl -cew10";
    };
  };
}
