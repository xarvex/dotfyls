{ config, lib, ... }:

lib.mkIf config.custom.window-managers.hyprland.enable {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      "$mod_ALT, F4, exit,"

      "$mod, Return, exec, [float;tile] ${config.custom.terminal.start.${config.custom.terminal.default}}"
    ];
    bindm = [
      "$mod, mouse:272, moveWindow"
      "$mod, mouse:273, resizeWindow"
    ];
  };
}
