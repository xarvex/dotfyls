{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = 2;
      gaps_in = 4;
      gaps_out = 4;
    };

    decoration = {
      rounding = 8;

      shadow = {
        range = 8;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };

      blur = {
        size = 2;
        passes = 3;
      };
    };

    animations = {
      bezier = [
        "overshot, 0.05, 0.9, 0.1, 1.05"
        "smoothin, 0.25, 1, 0.5, 1"
        "smoothout, 0.25, 1, 0.5, 1"
      ];

      # Unit: 100ms
      animation = [
        "windows, 1, 6, overshot"
        "windowsMove, 1, 4, smoothin, slide"
        "windowsOut, 1, 4, overshot, popin 85%"

        "layers, 1, 6, default, popin 85%"

        "fade, 1, 6, smoothin"
        "fadeOut, 1, 2, default"
        "fadeDim, 1, 6, smoothin"

        "border, 1, 6, default"
        "borderangle, 1, ${toString (10 * 60)}, default, loop"

        "workspaces, 1, 6, default"
      ];
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      disable_hyprland_qtutils_check = true;
    };
  };
}
