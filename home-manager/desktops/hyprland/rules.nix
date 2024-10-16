{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
  pCfg = config.dotfyls.programs;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings.windowrulev2 =
    [ "suppressevent maximize, class:^$" ]
    ++ lib.optionals pCfg.firefox.enable [
      "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
      "keepaspectratio, class:^(firefox)$, title:^(Picture-in-Picture)$"
      "pin, class:^(firefox)$, title:^(Picture-in-Picture)$"
    ]
    ++ lib.optionals pCfg.gnupg.enable [
      "dimaround, class:^(org.gnupg.pinentry-), floating: 1"
      "stayfocused, class:^(org.gnupg.pinentry-)"
    ]
    ++ lib.optionals pCfg.openrgb.enable [ "float, class:^(openrgb)$" ]
    ++ lib.optionals pCfg.xwaylandvideobridge.enable [
      "maxsize 1 1, class:^(xwaylandvideobridge)$"
      "noanim, class:^(xwaylandvideobridge)$"
      "noblur, class:^(xwaylandvideobridge)$"
      "nofocus, class:^(xwaylandvideobridge)$"
      "noinitialfocus, class:^(xwaylandvideobridge)$"
      "opacity 0.0 override, class:^(xwaylandvideobridge)$"
    ];
}
