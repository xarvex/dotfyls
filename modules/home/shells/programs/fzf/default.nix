{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.fzf;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "fzf" ] [ "programs" "fzf" ])
  ];

  options.dotfyls.shells.programs.fzf.enable = lib.mkEnableOption "fzf" // {
    default = cfg'.enableUseful || cfg'.enableUtility;
  };

  config = lib.mkIf cfg.enable { programs.fzf.enable = true; };
}
