{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.mkIf config.hm.custom.window-managers.hyprland.enable {
    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  })
]
