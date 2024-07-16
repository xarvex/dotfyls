{ config, lib, ... }:

lib.mkIf (config.dotfyls.desktops.enable && config.dotfyls.desktops.desktops.hyprland.enable) {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = config.dotfyls.desktops.desktops.hyprland.lock;
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 5 * 60;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 6.0 * 60;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 15 * 60;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
