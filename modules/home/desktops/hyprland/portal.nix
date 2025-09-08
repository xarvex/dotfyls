{ config, lib, ... }:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hyprland;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  xdg = {
    portal.config.hyprland.default = [
      "hyprland"
    ]
    ++ lib.optional (
      config.xdg.portal.config.common.default != ""
    ) config.xdg.portal.config.common.default;

    configFile."hypr/xdph.conf".text = lib.hm.generators.toHyprconf {
      attrs.screencopy.max_fps = builtins.head (
        builtins.sort (a: b: builtins.lessThan b a) (map (display: display.refresh) cfg'.displays)
      );
    };
  };

  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "tag +picker, title:Select what to share"

      "noscreenshare, title:Select what to share"
    ];
    permission = [
      "${lib.escapeRegex (toString config.wayland.windowManager.hyprland.finalPortalPackage)}/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow"
    ];
  };
}
