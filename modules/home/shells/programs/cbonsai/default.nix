# TODO: Make own version.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.cbonsai;
in
{
  options.dotfyls.shells.programs.cbonsai.enable = lib.mkEnableOption "cbonsai" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ cbonsai ]; };
}
