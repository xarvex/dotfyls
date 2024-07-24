{ config, lib, ... }:

{
  imports = [
    ./hyprland
    ./idles
    ./locks
  ];

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // { default = true; };
    default = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
      default = "hyprland";
      example = "hyprland";
      description = "Default desktop to use.";
    };

    wayland.sessionVariables = lib.mkOption {
      type = with lib.types; attrsOf (either int str);
      default = {
        NIXOS_OZONE_WL = 1;

        EGL_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11,*";
        QT_QPA_PLATFORM = "wayland;xcb";

        MOZ_ENABLE_WAYLAND = 1;
      };
      description = ''
        Environment variables that will be set for Wayland sessions.
        The variable values must be as described in {manpage}`environment.d(5)`.
      '';
    };

    displays = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "eDP-1";
            description = "Name of the display.";
          };
          width = lib.mkOption {
            type = lib.types.int;
            example = 1920;
            description = "Width of the display.";
          };
          height = lib.mkOption {
            type = lib.types.int;
            example = 1080;
            description = "Height of the display.";
          };
          refresh = lib.mkOption {
            type = lib.types.int;
            default = 60;
            example = 60;
            description = "Refresh of the display.";
          };
          position = lib.mkOption {
            type = lib.types.str;
            default = "0x0";
            description = "Position of the display.";
          };
          vertical = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Vertical state of the display.";
          };
        };
      });
      default = [ ];
      description = "Configuration of displays.";
    };
  };

  config = let cfg = config.dotfyls.desktops; in lib.mkIf cfg.enable {
    dotfyls.desktops.desktops.${cfg.default}.enable = true;
  };
}
