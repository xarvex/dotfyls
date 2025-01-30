{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "suppressevent maximize, class:.*"

      "float, class:discord|vesktop, title:Discord Popout"
      "pin, class:discord|vesktop, title:Discord Popout"

      "float, class:electron, title:Open Files"
      "size <50% <50%, class:electron, title:Open Files"

      "float, class:firefox, title:Library|Picture-in-Picture"
      "keepaspectratio, class:firefox, title:Picture-in-Picture"
      "pin, class:firefox, title:Picture-in-Picture"
      "size <50% <50%, class:firefox, title:Library"

      "dimaround, class:org\.gnupg\.pinentry-.+, floating: 1"
      "stayfocused, class:org\.gnupg\.pinentry-.+"

      "float, class:xdg-desktop-portal-.+"
      "size <50% <50%, class:xdg-desktop-portal-.+"

      "maxsize 1 1, class:xwaylandvideobridge"
      "noanim, class:xwaylandvideobridge"
      "noblur, class:xwaylandvideobridge"
      "nofocus, class:xwaylandvideobridge"
      "noinitialfocus, class:xwaylandvideobridge"
      "opacity 0.0 override, class:xwaylandvideobridge"
    ];
    layerrule = [
      "blur, dotpanel-.+"
      "ignorezero, dotpanel-.+"
    ];
  };
}
