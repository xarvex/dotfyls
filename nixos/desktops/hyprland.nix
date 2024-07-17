{ config, lib, pkgs, ... }:

{
  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // { default = config.hm.dotfyls.desktops.desktops.hyprland.enable; };
    command = lib.mkOption {
      type = lib.types.str;
      default = "dbus-run-session Hyprland";
      example = "dbus-run-session Hyprland";
      description = "Command to run Hyprland.";
    };
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && config.dotfyls.desktops.desktops.hyprland.enable) {
    programs.hyprland.enable = true;

    security.pam.services.hyprlock = { };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
