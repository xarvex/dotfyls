{ config, lib, ... }:

lib.mkIf config.dotfyls.desktop.hyprland.enable {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      "$mod_ALT, F4, exit,"

      "$mod, Return, exec, [float;tile] ${config.dotfyls.terminal.start.${config.dotfyls.terminal.default}}"
    ]
    ++ lib.optionals config.dotfyls.programs.rofi.enable [
      "$mod_SHIFT, Return, exec, rofi -show drun"
      "$mod_CTRL, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    ];
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
