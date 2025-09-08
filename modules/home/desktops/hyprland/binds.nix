{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER_ALT, F4, ${
        if cfg'.wayland.uwsm.enable then
          "exec, ${
            lib.optionalString (!config.targets.genericLinux.enable) "/run/current-system/sw/bin/"
          }uwsm stop"
        else
          "exit,"
      }"

      "SUPER, BackSpace, killactive,"

      "SUPER, H, ${if cfg.scrolling then "layoutmsg, focus" else "movefocus,"} l"
      "SUPER, J, ${if cfg.scrolling then "layoutmsg, focus" else "movefocus,"} d"
      "SUPER, K, ${if cfg.scrolling then "layoutmsg, focus" else "movefocus,"} u"
      "SUPER, L, ${if cfg.scrolling then "layoutmsg, focus" else "movefocus,"} r"

      "SUPER_SHIFT, H, ${if cfg.scrolling then "layoutmsg, movewindowto" else "movewindow,"} l"
      "SUPER_SHIFT, J, ${if cfg.scrolling then "layoutmsg, movewindowto" else "movewindow,"} d"
      "SUPER_SHIFT, K, ${if cfg.scrolling then "layoutmsg, movewindowto" else "movewindow,"} u"
      "SUPER_SHIFT, L, ${if cfg.scrolling then "layoutmsg, movewindowto" else "movewindow,"} r"

      "SUPER_ALT, ${if cfg.scrolling then "K" else "H"}, workspace, m-1"
      "SUPER_ALT, ${if cfg.scrolling then "J" else "L"}, workspace, m+1"

      "SUPER_ALT_SHIFT, ${if cfg.scrolling then "K" else "H"}, movetoworkspace, r-1"
      "SUPER_ALT_SHIFT, ${if cfg.scrolling then "J" else "L"}, movetoworkspace, r+1"

      "SUPER, F, fullscreen, 0"
      "SUPER_ALT, F, fullscreenstate, -1 2"

      "SUPER, Z, fullscreen, 1"
      "SUPER_ALT, Z, togglefloating,"
    ]
    ++ lib.optionals cfg.scrolling [
      "SUPER_ALT, H, layoutmsg, move -col"
      "SUPER_ALT, L, layoutmsg, move +col"
    ]
    ++ lib.flatten (
      self.lib.genWorkspaceList (
        workspace: key: [
          "SUPER, ${key}, workspace, ${toString workspace}"
          "SUPER_SHIFT, ${key}, movetoworkspace, ${toString workspace}"
        ]
      )
    );
    binde = [
      "SUPER_CTRL, J, ${if cfg.scrolling then "layoutmsg, colresize -conf" else "resizeactive, 0 20"}"
      "SUPER_CTRL, K, ${if cfg.scrolling then "layoutmsg, colresize +conf" else "resizeactive, 0 -20"}"
    ]
    ++ lib.optionals (!cfg.scrolling) [
      "SUPER_CTRL, H, resizeactive, -20 0"
      "SUPER_CTRL, L, resizeactive, 20 0"
    ];
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, ${if cfg.scrolling then "layoutmsg colresize" else "resizewindow"}"
    ];
  };
}
