{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.tldr;
in
{
  options.dotfyls.shells.programs.tldr = {
    enable = lib.mkEnableOption "tldr" // {
      default = cfg'.enableUseful;
    };
    package = lib.mkPackageOption pkgs "tlrc" { };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/tlrc".cache = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
