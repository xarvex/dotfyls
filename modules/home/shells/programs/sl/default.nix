# TODO: Make own version.
{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.sl;
in
{
  options.dotfyls.shells.programs.sl = {
    enable = lib.mkEnableOption "Steam Locomotive" // {
      default = cfg'.enableFun;
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
