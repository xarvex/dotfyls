{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    general = {
      no_focus_fallback = true;

      snap = {
        enabled = true;
        border_overlap = true;
        respect_gaps = true;
      };
    };

    dwindle.preserve_split = true;

    master.new_status = "master";

    input = {
      numlock_by_default = config.dotfyls.management.input.numlockDefault;
      touchpad = {
        natural_scroll = true;
        clickfinger_behavior = true;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_touch = true;
      workspace_swipe_cancel_ratio = 0.15;
    };

    binds.workspace_center_on = 1;

    cursor = {
      warp_on_change_workspace = 1;
      warp_on_toggle_special = 1;
    };
  };
}
