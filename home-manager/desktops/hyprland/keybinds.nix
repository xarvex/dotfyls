{ config, lib, self, ... }:

lib.mkIf (config.dotfyls.desktops.enable && config.dotfyls.desktops.desktops.hyprland.enable) {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      "$mod_ALT, F4, exit,"

      "$mod, BackSpace, killactive,"

      "$mod, h, movefocus, l"
      "$mod, j, movefocus, d"
      "$mod, k, movefocus, u"
      "$mod, l, movefocus, r"

      "$mod_SHIFT, h, movewindow, l"
      "$mod_SHIFT, j, movewindow, d"
      "$mod_SHIFT, k, movewindow, u"
      "$mod_SHIFT, l, movewindow, r"

      "$mod, f, fullscreen, 0"
      "$mod_ALT, f, fakefullscreen,"

      "$mod, z, fullscreen, 1"
      "$mod_ALT, z, togglefloating,"

      "$mod_ALT, h, workspace, m-1"
      "$mod_ALT, l, workspace, m+1"

      "$mod_ALT_SHIFT, h, movetoworkspace, r-1"
      "$mod_ALT_SHIFT, l, movetoworkspace, r+1"
    ]
    ++ lib.flatten (self.lib.genWorkspaceList (workspace: key: [
      "$mod, ${key}, workspace, ${toString workspace}"
      "$mod_SHIFT, ${key}, movetoworkspace, ${toString workspace}"
    ]))
    ++ lib.optionals (config.dotfyls.terminals.xdgExec != null) [
      "$mod, Return, exec, ${lib.getExe config.dotfyls.terminals.xdgExec}"
    ]
    ++ lib.optionals config.dotfyls.programs.discord.enable [
      "$mod, d, exec, Discord"
    ]
    ++ lib.optionals config.dotfyls.programs.firefox.enable [
      "$mod, w, exec, firefox"
    ]
    ++ lib.optionals config.dotfyls.programs.nemo.enable [
      "$mod, e, exec, nemo"
    ]
    ++ lib.optionals config.dotfyls.programs.rofi.enable [
      "$mod_SHIFT, Return, exec, rofi -show drun"
      "$mod_SHIFT, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    ];

    binde = [
      "$mod_CTRL, h, resizeactive, -20 0"
      "$mod_CTRL, j, resizeactive, 0 20"
      "$mod_CTRL, k, resizeactive, 0 -20"
      "$mod_CTRL, l, resizeactive, 20 0"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
