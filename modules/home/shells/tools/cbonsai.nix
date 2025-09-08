# TODO: Make own version.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.cbonsai;
in
{
  options.dotfyls.shells.tools.cbonsai.enable = lib.mkEnableOption "cbonsai" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ cbonsai ]; };
}
