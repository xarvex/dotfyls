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
    ./cliphist
    ./desktops
    ./dotpanel
    ./swww

    ./dunst.nix
    ./rofi.nix
    ./soteria.nix
    ./wl-clipboard.nix

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
              connector = lib.mkOption {
                type = with lib.types; nullOr str;
                default = null;
                example = "eDP-1";
                description = "Connector of the display.";
              };
              make = lib.mkOption {
                type = with lib.types; nullOr str;
                description = "Make of the display.";
              };
              model = lib.mkOption {
                type = with lib.types; nullOr str;
                description = "Model of the display.";
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
              vrr = lib.mkEnableOption "VRR for the display";
              vertical = lib.mkEnableOption "vertical transformation for the display";
              position = lib.mkOption {
                type = lib.types.str;
                default = "0x0";
                description = "Position of the display.";
              };
              workspaces = lib.mkOption {
                type = with lib.types; listOf int;
                default = [ ];
                description = "Workspaces of the display.";
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

    xdg = {
      portal.xdgOpenUsePortal = true;

      configFile."menus/applications.menu".source = ./applications.menu;
    };

    dconf.settings."ca/desrt/dconf-editor".show-warning = false;
  };
}
