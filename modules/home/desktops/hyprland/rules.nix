{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;

  gaps = toString (
    config.wayland.windowManager.hyprland.settings.general.border_size
    + config.wayland.windowManager.hyprland.settings.general.gaps_out
  );
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings.windowrule = lib.mkBefore [
    "suppressevent maximize, class:.*"

    "float, tag:dialog"
    "size 40% 40%, tag:dialog"

    "float, tag:picker"
    "size 50% 50%, tag:picker"

    "float, tag:popout"
    "pin, tag:popout"
    # "size 35% 35%, tag:popout"
    "move 100%-w-${gaps} 100%-w-${gaps}, tag:popout"
    "noinitialfocus, tag:popout"

    "stayfocused, tag:important-prompt"
    "pin, tag:important-prompt"
  ];
}
