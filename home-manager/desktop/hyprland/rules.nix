{ config, lib, ... }:

lib.mkIf config.dotfyls.desktop.hyprland.enable {
  wayland.windowManager.hyprland.settings.windowrulev2 = [ ]
    ++ lib.optionals config.dotfyls.programs.xwaylandvideobridge.enable [
    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"
  ];
}
