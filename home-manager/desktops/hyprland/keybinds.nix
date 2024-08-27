{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;

  getPkg = cfg': if (cfg' ? finalPackage) then cfg'.finalPackage else cfg'.package;
  withProgram = name: generator:
    let
      cfg' = config.dotfyls.programs.${name};
    in
    lib.optionals cfg'.enable (generator (getPkg cfg'));
in
lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
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
      "$mod_ALT, f, fullscreenstate, -1 2"

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
    ++ lib.optionals (config.dotfyls.media.audio.enable && config.dotfyls.media.wireplumber.enable) (
      let
        wireplumber = getPkg config.dotfyls.media.wireplumber;
      in
      [
        ", XF86AudioMute, exec, ${lib.getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, ${lib.getExe' wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, ${lib.getExe' wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ]
    )
    ++ lib.optionals (config.dotfyls.terminals.xdgExec != null) [
      "$mod, Return, exec, ${lib.getExe config.dotfyls.terminals.xdgExec}"
    ]
    ++ withProgram "firefox" (firefox: [
      "$mod, w, exec, ${lib.getExe firefox}"
    ])
    ++ withProgram "nemo" (nemo: [
      "$mod, e, exec, ${lib.getExe nemo}"
    ])
    ++ withProgram "rofi" (rofi: ([
      "$mod_SHIFT, Return, exec, ${lib.getExe rofi} -show drun"
    ]
    ++ withProgram "cliphist" (cliphist: withProgram "wl-clipboard" (wl-clipboard: [
      "$mod_SHIFT, v, exec, ${lib.getExe cliphist} list | ${lib.getExe rofi} -dmenu | ${lib.getExe cliphist} decode | ${lib.getExe' wl-clipboard "wl-copy"}"
    ]))))
    ++ (
      let
        mkBinds = name: [
          "$mod, d, exec, ${lib.getExe (getPkg config.dotfyls.programs.${name})}"
        ];
      in
      if config.dotfyls.programs.vesktop.enable then mkBinds "vesktop"
      else if config.dotfyls.programs.discord.enable then mkBinds "discord"
      else [ ]
    );

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
