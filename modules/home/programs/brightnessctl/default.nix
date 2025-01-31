{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.programs.brightnessctl;
in
{
  options.dotfyls.programs.brightnessctl.enable = lib.mkEnableOption "brightnessctl" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ brightnessctl ]; };
}
