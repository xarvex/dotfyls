{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;

  inherit (config.dotfyls.meta.machine) isVirtual;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = if isVirtual then 0 else 2;
      gaps_in = if isVirtual then 0 else 4;
      gaps_out = if isVirtual then 0 else 4;
    };

    decoration = {
      rounding = if isVirtual then 0 else 8;

      blur = {
        enabled = !isVirtual;
        size = 3;
        passes = 3;
      };

      shadow = {
        enabled = !isVirtual;
        range = 8;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
    };

    animations = {
      enabled = !isVirtual;
      first_launch_animation = false;

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

        "workspaces, 1, ${
          if cfg.scrolling then "4" else "6"
        }, default${lib.optionalString cfg.scrolling ", slidevert"}"
      ];
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };

    cursor = {
      sync_gsettings_theme = false;
      inactive_timeout = 5 * 60;
      enable_hyprcursor = false;
    };
  };
}
