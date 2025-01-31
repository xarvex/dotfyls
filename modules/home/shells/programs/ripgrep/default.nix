{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.ripgrep;
in
{
  options.dotfyls.shells.programs.ripgrep.enable = lib.mkEnableOption "ripgrep" // {
    default = cfg'.enableUseful || cfg'.enableUtility;
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;

      arguments = [
        "--glob=!.git"
        "--follow"
        "--hidden"
        "--smart-case"
      ];
    };
  };
}
