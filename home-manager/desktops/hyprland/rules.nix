{ config, lib, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
in
lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings.windowrulev2 = [ ]
    ++ lib.optionals config.dotfyls.programs.firefox.enable [
    "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "keepaspectratio, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "pin, class:^(firefox)$, title:^(Picture-in-Picture)$"
  ]
    ++ lib.optionals config.dotfyls.programs.gnupg.enable [
    "dimaround, class:^(org.gnupg.pinentry-), floating: 1"
    "stayfocused, class:^(org.gnupg.pinentry-)"
  ]
    ++ lib.optionals config.dotfyls.programs.openrgb.enable [
    "float, class:^(openrgb)$"
  ]
    ++ lib.optionals config.dotfyls.programs.xwaylandvideobridge.enable [
    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"
  ];
}
