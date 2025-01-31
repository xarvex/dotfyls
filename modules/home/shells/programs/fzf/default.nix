{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.fzf;
in
{
  options.dotfyls.shells.programs.fzf.enable = lib.mkEnableOption "fzf" // {
    default = cfg'.enableUseful || cfg'.enableUtility;
  };

  config = lib.mkIf cfg.enable { programs.fzf.enable = true; };
}
