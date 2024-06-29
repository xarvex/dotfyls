{ config, lib, ... }:

lib.mkIf config.custom.desktop.hyprland.enable {
  wayland.windowManager.hyprland.settings.windowrulev2 = [ ]
    ++ lib.optionals config.custom.programs.xwaylandvideobridge.enable [
    "opacity 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"
  ];
}
