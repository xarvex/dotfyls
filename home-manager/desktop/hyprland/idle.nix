{ config, lib, ... }:

let
  lock = config.dotfyls.desktop.hyprland.lock;
in
lib.mkIf config.dotfyls.desktop.hyprland.enable {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = lock;
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 5 * 60;
          on-timeout = lock;
        }
        {
          timeout = 5.5 * 60;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 6 * 60;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
