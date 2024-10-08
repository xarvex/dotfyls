{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.desktops.hyprland;
  pCfg = config.dotfyls.programs;

  withCfgPkg = cfg: generator: lib.optionals cfg.enable (generator (self.lib.getCfgPkg cfg));
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
      ++ lib.optionals config.dotfyls.media.audio.enable (
        (withCfgPkg config.dotfyls.media.wireplumber (wireplumber: [
          ", XF86AudioMute, exec, ${lib.getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, ${lib.getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ]))
        ++ withCfgPkg config.dotfyls.media.mpris2.playerctl (playerctl: [
          ", XF86AudioNext, exec, ${lib.getExe playerctl} next"
          ", XF86AudioPlay, exec, ${lib.getExe playerctl} play-pause"
          ", XF86AudioPrev, exec, ${lib.getExe playerctl} previous"
        ])
      )
      ++ withCfgPkg config.dotfyls.terminals.xdg-terminal-exec (xdg-terminal-exec: [
        "$mod, Return, exec, ${lib.getExe xdg-terminal-exec}"
      ])
      ++ withCfgPkg pCfg.firefox (firefox: [ "$mod, W, exec, ${lib.getExe firefox}" ])
      ++ withCfgPkg pCfg.nemo (nemo: [ "$mod, E, exec, ${lib.getExe nemo}" ])
      ++ withCfgPkg pCfg.obsidian (obsidian: [ "$mod, O, exec, ${lib.getExe obsidian}" ])
      ++ withCfgPkg pCfg.rofi (
        rofi:
        (
          # HACK: desktop entries are showing other languages when explicit
          # English entry does not exist, must figure out how to show default.
          [ "$mod_SHIFT, Return, exec, LANGUAGE='' ${lib.getExe rofi} -show drun" ]
          ++ withCfgPkg pCfg.cliphist (
            cliphist:
            withCfgPkg pCfg.wl-clipboard (wl-clipboard: [
              "$mod_SHIFT, V, exec, ${lib.getExe cliphist} list | ${lib.getExe rofi} -dmenu | ${lib.getExe cliphist} decode | ${lib.getExe' wl-clipboard "wl-copy"}"
            ])
          )
        )
      )
      ++ (
        let
          mkBinds = name: [ "$mod, D, exec, ${self.lib.getCfgExe pCfg.${name}}" ];
        in
        if pCfg.vesktop.enable then
          mkBinds "vesktop"
        else if pCfg.discord.enable then
          mkBinds "discord"
        else
          [ ]
      );

    binde =
      [
        "$mod_CTRL, H, resizeactive, -20 0"
        "$mod_CTRL, J, resizeactive, 0 20"
        "$mod_CTRL, K, resizeactive, 0 -20"
        "$mod_CTRL, L, resizeactive, 20 0"

        ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"
        ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set +5%"
      ]
      ++ lib.optionals config.dotfyls.media.audio.enable (
        withCfgPkg config.dotfyls.media.wireplumber (wireplumber: [
          ", XF86AudioLowerVolume, exec, ${lib.getExe' wireplumber "wpctl"} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, ${lib.getExe' wireplumber "wpctl"} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ])
      );

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
