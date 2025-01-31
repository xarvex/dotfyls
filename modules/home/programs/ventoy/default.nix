{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.programs.ventoy;
in
{
  options.dotfyls.programs.ventoy.enable = lib.mkEnableOption "Ventoy" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ ventoy-full ]; };
}
