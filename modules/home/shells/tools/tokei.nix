{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.tokei;
in
{
  options.dotfyls.shells.tools.tokei.enable = lib.mkEnableOption "Tokei" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ tokei ]; };
}
