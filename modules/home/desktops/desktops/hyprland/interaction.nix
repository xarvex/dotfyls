{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    general.no_focus_fallback = true;

    dwindle.preserve_split = true;

    master.new_status = "master";

    input = {
      touchpad = {
        natural_scroll = true;
        clickfinger_behavior = true;
      };

      touchdevice.output = lib.mkIf (builtins.any (display: display.connector == "eDP-1") cfg'.displays) (
        lib.mkDefault "eDP-1"
      );
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_touch = true;
    };

    binds.workspace_center_on = true;
  };
}
