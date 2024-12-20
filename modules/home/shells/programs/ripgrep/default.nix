{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.ripgrep;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "ripgrep" ] [ "programs" "ripgrep" ])
  ];

  options.dotfyls.shells.programs.ripgrep.enable = lib.mkEnableOption "ripgrep" // {
    default = cfg'.enableUseful || cfg'.enableUtility;
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;

      arguments = [
        "--glob=!.git/*"
        "--glob=!*/.git/*"
        "--follow"
        "--hidden"
        "--smart-case"
      ];
    };
  };
}
