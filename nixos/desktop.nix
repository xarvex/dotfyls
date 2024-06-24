{ config, lib, pkgs, user, ... }:

{
  options.custom.desktop = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland (NixOS)" // { default = config.hm.custom.desktop.hyprland.enable; };
    sddm.enable = lib.mkEnableOption "Enable SDDM (NixOS)" // { default = true; };
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.desktop.hyprland.enable {
      programs.hyprland.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };
    })

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

      systemd.tmpfiles.rules = [
        "d /var/lib/sddm 0755 root root - -"

        # Not really last, but allows specifying as default user on each boot
        "f+ /var/lib/sddm/state.conf - - - - ${builtins.replaceStrings ["\n"] ["\\n"] (lib.generators.toINI { } { Last.User = user; })}"
      ];
    })
  ];
}
