{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.thefuck;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "thefuck" ] [ "programs" "thefuck" ])
  ];

  options.dotfyls.shells.programs.thefuck.enable = lib.mkEnableOption "The Fuck" // {
    default = cfg'.enableFun || cfg'.enableUseful;
  };

  config = lib.mkIf cfg.enable {
    programs.thefuck.enable = true;

    xdg.configFile."thefuck/settings.py".source = ./settings.py;
  };
}
