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
  cfg = cfg'.cbonsai;
in
{
  options.dotfyls.shells.programs.cbonsai = {
    enable = lib.mkEnableOption "cbonsai" // {
      default = cfg'.enableFun;
    };
    package = lib.mkPackageOption pkgs "cbonsai" { };
  };

  config = lib.mkIf cfg.enable { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
