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
      "size 50% 50%, class:electron, title:Open Files"

      "float, class:firefox, title:About Mozilla Firefox"
      "float, class:firefox|librewolf, title:Library|Picture-in-Picture"
      "keepaspectratio, class:firefox|librewolf, title:Picture-in-Picture"
      "pin, class:firefox|librewolf, title:Picture-in-Picture"
      "size 25% 25%, class:firefox, title:About Mozilla Firefox"
      "size 50% 50%, class:firefox|librewolf, title:Library"

      "float, class:librewolf, title:About LibreWolf"
      "size 25% 25%, class:librewolf, title:About LibreWolf"

      "center, class:soffice, floating:1"
      "size 50% 50%, class:soffice, floating:1"

      "dimaround, class:org\.gnupg\.pinentry-.+, floating:1"
      "stayfocused, class:org\.gnupg\.pinentry-.+"

      "float, class:xdg-desktop-portal-.+"
      "size 50% 50%, class:xdg-desktop-portal-.+"

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
