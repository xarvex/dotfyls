{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "keepaspectratio, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "pin, class:^(firefox)$, title:^(Picture-in-Picture)$"

    "dimaround, class:^(org.gnupg.pinentry-), floating: 1"
    "stayfocused, class:^(org.gnupg.pinentry-)"

    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "nofocus, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"

    "suppressevent maximize, class:.*"
  ];
}
