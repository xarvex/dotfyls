{ config, lib, pkgs, ... }:

{
  options.custom.desktop.sddm.enable = lib.mkEnableOption "Enable SDDM" // { default = true; };

  config = lib.mkMerge [
    (lib.mkIf config.custom.desktop.sddm.enable {
      environment.systemPackages = with pkgs; [
        (catppuccin-sddm.override { flavor = "mocha"; })
      ];

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "catppuccin-mocha";
      };
    })
    (lib.mkIf config.hm.custom.desktop.hyprland.enable {
      programs.hyprland.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };
    })
  ];
}
