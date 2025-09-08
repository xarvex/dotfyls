{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.graphics;
  cfg = cfg'.brightness;
in
{
  options.dotfyls.graphics.brightness.enable = lib.mkEnableOption "brightnessctl" // {
    default = config.dotfyls.meta.machine.isLaptop;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = with pkgs; [ brightnessctl ];

    wayland.windowManager.hyprland.settings.bindle =
      let
        brightnessctl = lib.getExe pkgs.brightnessctl;
      in
      [
        ", XF86MonBrightnessDown, exec, ${brightnessctl} --min-value=2 --exponent=4 set 5%-"
        ", XF86MonBrightnessUp, exec, ${brightnessctl} --min-value=2 --exponent=4 set +5%"
      ];
  };
}
