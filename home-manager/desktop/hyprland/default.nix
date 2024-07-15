{ config, lib, pkgs, ... }:

{
  imports = [
    ./idle.nix
    ./keybinds.nix
    ./lock.nix
    ./rules.nix
  ];

  options.dotfyls.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // { default = true; };
    lock = lib.mkOption {
      type = lib.types.str;
      default = "pidof hyprlock || hyprlock";
      description = "Lock command to use.";
    };
  };

  config = lib.mkIf config.dotfyls.desktop.hyprland.enable {
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

        monitor = (lib.forEach config.dotfyls.desktop.displays (display:
          lib.concatStringsSep ", " ([
            display.name
            "${toString display.width}x${toString display.height}@${toString display.refresh}"
            display.position
            "1"
          ] ++ lib.optionals display.vertical [ "transform, 1" ])
        )) ++ [ ", preferred, auto, auto" ];

        exec-once = [
          "wl-paste --watch cliphist store"
        ];
      };

      systemd = {
        enableXdgAutostart = true;
        variables = [ "--all" ];
      };
    };

    dotfyls.persist.directories = [ ".cache/hyprland" ]; # crash reports
  };
}
