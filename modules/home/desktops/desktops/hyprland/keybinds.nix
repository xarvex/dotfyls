{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind =
      [
        "$mod_ALT, F4, exit,"

        "$mod, BackSpace, killactive,"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        "$mod_SHIFT, H, movewindow, l"
        "$mod_SHIFT, J, movewindow, d"
        "$mod_SHIFT, K, movewindow, u"
        "$mod_SHIFT, L, movewindow, r"

        "$mod, F, fullscreen, 0"
        "$mod_ALT, F, fullscreenstate, -1 2"

        "$mod, Z, fullscreen, 1"
        "$mod_ALT, Z, togglefloating,"

        "$mod_ALT, H, workspace, m-1"
        "$mod_ALT, L, workspace, m+1"

        "$mod_ALT_SHIFT, H, movetoworkspace, r-1"
        "$mod_ALT_SHIFT, L, movetoworkspace, r+1"
      ]
      ++ lib.flatten (
        self.lib.genWorkspaceList (
          workspace: key: [
            "$mod, ${key}, workspace, ${toString workspace}"
            "$mod_SHIFT, ${key}, movetoworkspace, ${toString workspace}"
          ]
        )
      )
      ++ [
        "$mod, W, exec, firefox"
        "$mod, E, exec, nemo"
        "$mod, O, exec, obsidian"
        "$mod, D, exec, if command -v vesktop; then vesktop; else Discord; fi"

        "$mod, Return, exec, xdg-terminal-exec"

        "$mod_SHIFT, Return, exec, rofi -show drun -show-icons"
        "$mod_SHIFT, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"

        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"

        # INFO: Electron Wayland does not capture shortcut unless focused.
        # See: https://github.com/hyprwm/Hyprland/issues/6576
        # Otherwise, this would be used:
        # `"$mod_CTRL_SHIFT, M, sendshortcut, CTRL_SHIFT, M, class:vesktop"`
        # TODO: Implement a proper workaround.
        # This exec does not change focus if window is on a different monitor than the current.
        "$mod_CTRL_SHIFT, M, exec, hyprctl dispatch focuswindow class:vesktop && hyprctl dispatch sendshortcut CONTROL SHIFT, M, class:vesktop && hyprctl dispatch focuscurrentorlast"
      ];

    binde = [
      "$mod_CTRL, H, resizeactive, -20 0"
      "$mod_CTRL, J, resizeactive, 0 20"
      "$mod_CTRL, K, resizeactive, 0 -20"
      "$mod_CTRL, L, resizeactive, 20 0"

      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
