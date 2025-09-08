{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.portal;
in
{
  options.dotfyls.desktops.portal = {
    enable = lib.mkEnableOption "XDG Desktop Portal" // {
      default = true;
    };

    useGTK = lib.mkEnableOption "GTK XDG Desktop Portal" // {
      default = true;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.sessionVariables = {
      GTK_USE_PORTAL = 1;
      PLASMA_INTEGRATION_USE_PORTAL = 1;
    };

    xdg.portal = {
      enable = true;
      extraPortals = lib.optional cfg.useGTK pkgs.xdg-desktop-portal-gtk;

      xdgOpenUsePortal = true;
      config.common.default = lib.optional cfg.useGTK "gtk";
    };

    wayland.windowManager.hyprland.settings.windowrule = [
      "tag +picker, title:Open Files"

      "noscreenshare, title:Open Files"

      "tag +picker, class:xdg-desktop-portal-.+"

      "noscreenshare, class:xdg-desktop-portal-.+"
    ];
  };
}
