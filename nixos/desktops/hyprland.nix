{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
  hmCfg = config.hm.dotfyls.desktops.desktops.hyprland;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "desktops" "desktops" "hyprland" ]
      [ "programs" "hyprland" ])
  ];

  options.dotfyls.desktops.desktops.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // { default = hmCfg.desktops.hyprland.enable; };
    command = pkgs.lib.dotfyls.mkCommandOption "Hyprland" // {
      default = pkgs.lib.dotfyls.mkCommand {
        runtimeInputs = [ cfg.package pkgs.dbus ];
        text = "exec dbus-run-session Hyprland";
      };
    };
  };

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls.programs.gvfs.enable = lib.mkDefault true;

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
