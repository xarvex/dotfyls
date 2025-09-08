{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.ripgrep;
in
{
  options.dotfyls.shells.tools.ripgrep.enable = lib.mkEnableOption "ripgrep" // {
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
