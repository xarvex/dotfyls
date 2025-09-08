{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  wayland.windowManager.hyprland = lib.mkMerge [
    {
      settings.permission = lib.mkMerge [
        (map (
          plugin:
          "${
            lib.escapeRegex (
              if lib.types.package.check plugin then "${plugin}/lib/lib${plugin.pname}.so" else plugin
            )
          }, plugin, allow"
        ) config.wayland.windowManager.hyprland.plugins)
        (lib.mkAfter [ ".*, plugin, deny" ])
      ];
    }

    (lib.mkIf cfg.scrolling {
      plugins = with pkgs.hyprlandPlugins; [ hyprscrolling ];

      settings = {
        general.layout = "scrolling";

        plugin.hyprscrolling = {
          fullscreen_on_one_column = true;
          focus_fit_method = 1;
        };
      };
    })

    (lib.mkIf cfg.gestures {
      plugins = with pkgs.hyprlandPlugins; [ hyprgrass ];

      settings.plugin.touch_gestures.hyprgrass-bindm = [
        ", longpress:2, movewindow"
        ", longpress:3, ${if cfg.scrolling then "layoutmsg, colresize" else "resizewindow"}"
      ];
    })
  ];
}
