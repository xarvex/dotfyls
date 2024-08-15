{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.desktops.desktops.hyprland;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "desktops" "desktops" "hyprland" ]
      [ "programs" "hyprland" ])
  ];

  config = lib.mkIf (config.dotfyls.desktops.enable && cfg.enable) {
    dotfyls.programs.gvfs.enable = lib.mkDefault true;

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
