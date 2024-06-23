{ config, lib, pkgs, ... }:

{
  imports = [
    ./keybind.nix
  ];

  options.custom.window-managers.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // { default = true; };
  };

  config = lib.mkIf config.custom.window-managers.hyprland.enable {
    home.packages = with pkgs; [
      cliphist
      wl-clipboard
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        env = [
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
        ];

        input = {
          kb_layout = "us";
          follow_mouse = 1;

          touchpad = {
            disable_while_typing = true;
            natural_scroll = false;
          };
        };

        exec-once = [
          "wl-paste --watch cliphist store"
        ];
      };

      systemd.variables = [ "--all" ];
    };

    custom.persist.directories = [ ".cache/hyprland" ]; # crash reports
  };
}
