# TODO: Make own version.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.sl;
in
{
  options.dotfyls.shells.programs.sl.enable = lib.mkEnableOption "Steam Locomotive" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [ sl ];

      shellAliases.sl = "sl -cew10";
    };
  };
}
