{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.qt;
in
{
  options.dotfyls.desktops.qt.enable = lib.mkEnableOption "Qt" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    qt = {
      enable = true;

      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}
