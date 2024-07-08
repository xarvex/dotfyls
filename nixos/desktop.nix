{ config, lib, pkgs, user, ... }:

{
  options.dotfyls.desktop = {
    hyprland.enable = lib.mkEnableOption "Hyprland" // { default = config.hm.dotfyls.desktop.hyprland.enable; };
    sddm.enable = lib.mkEnableOption "SDDM" // { default = true; };
  };

  config = lib.mkMerge [
    {
      services.xserver = {
        updateDbusEnvironment = true;
        xkb = {
          layout = "us";
          variant = "";
        };
        excludePackages = [ pkgs.xterm ];
      };

      security.polkit.enable = true;
    }

    (lib.mkIf config.dotfyls.desktop.hyprland.enable {
      programs.hyprland.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    })

    (lib.mkIf config.dotfyls.desktop.sddm.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "catppuccin-mocha";
      };

      environment.systemPackages = with pkgs; [
        (catppuccin-sddm.override { flavor = "mocha"; })
      ];

      systemd = {
        services."autovt@tty1".enable = false;
        tmpfiles.rules = [
          "d /var/lib/sddm 0755 root root - -"

          # Not really last, but allows specifying as default user on each boot
          "f+ /var/lib/sddm/state.conf - - - - ${builtins.replaceStrings ["\n"] ["\\n"] (lib.generators.toINI { } { Last.User = user; })}"
        ];
      };
    })
  ];
}
