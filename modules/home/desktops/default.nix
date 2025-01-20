{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops;
in
{
  imports = [
    ./desktops
    ./dotpanel

    (self.lib.mkSelectorModule [ "dotfyls" "desktops" ] {
      name = "default";
      default = "hyprland";
      example = "hyprland";
      description = "Default desktop to use.";
    })
  ];

  options.dotfyls.desktops =
    let
      mkTimeoutOption =
        action: default:
        lib.mkOption {
          type = lib.types.int;
          inherit default;
          example = default;
          description = "Timeout in seconds before ${action}.";
        };
    in
    {
      enable = lib.mkEnableOption "desktops" // {
        default = true;
      };

      lockTimeout = mkTimeoutOption "locking" (5 * 60);
      displayTimeout = mkTimeoutOption "display off" (cfg.lockTimeout + 30);
      suspendTimeout = mkTimeoutOption "suspend" (cfg.lockTimeout + (10 * 60));

      wayland.sessionVariables = lib.mkOption {
        type = with lib.types; attrsOf (either int str);
        default = { };
        description = ''
          Environment variables that will be set for Wayland sessions.
          The variable values must be as described in {manpage}`environment.d(5)`.
        '';
      };

      displays = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
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
              scale = lib.mkOption {
                type = with lib.types; either (enum [ "auto" ]) float;
                default = "auto";
                description = "Scale of the display.";
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
          }
        );
        default = [ ];
        description = "Configuration of displays.";
      };
    };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      desktops.wayland.sessionVariables = {
        EGL_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11,*";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland,x11,windows";
        CLUTTER_BACKEND = "wayland";

        NIXOS_OZONE_WL = 1;
        MOZ_ENABLE_WAYLAND = 1;

        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      };

      file = {
        ".local/share/applications" = {
          mode = "0700";
          persist = true;
        };
        ".local/share/icons".persist = true;
      };
    };

    xdg.configFile."menus/applications.menu".source = ./applications.menu;

    dconf.settings."ca/desrt/dconf-editor".show-warning = false;
  };
}
