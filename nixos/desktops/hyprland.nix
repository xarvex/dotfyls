{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "desktops" "desktops" "hyprland" "package" ]
      [ "programs" "hyprland" "package" ])
  ];

  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // { default = config.hm.dotfyls.desktops.desktops.hyprland.enable; };
    command = pkgs.lib.dotfyls.mkCommandOption "Hyprland" // {
      default = pkgs.lib.dotfyls.mkCommand {
        runtimeInputs = [ cfg.package pkgs.dbus ];
        text = "exec dbus-run-session Hyprland";
      };
    };
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
