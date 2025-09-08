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
    ./hyprland

    ./cliphist.nix
    ./dotpanel.nix
    ./dunst.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./portal.nix
    ./rofi.nix
    ./soteria.nix
    ./swww.nix
    ./wayland.nix
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
      default = lib.mkOption {
        type = lib.types.enum [ "hyprland" ];
        default = "hyprland";
        example = "hyprland";
        description = "Default desktop to use.";
      };

      lockTimeout = mkTimeoutOption "locking" (5 * 60);
      displayTimeout = mkTimeoutOption "display off" (cfg.lockTimeout + 30);
      suspendTimeout = mkTimeoutOption "suspend" (cfg.lockTimeout + (10 * 60));

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
              touchscreen = lib.mkEnableOption "touchscreen for the display";
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
      desktops = self.lib.enableSelected cfg.default [ "hyprland" ];

      file = {
        ".local/share/applications" = {
          mode = "0700";
          persist = true;
        };
        ".local/share/icons".persist = true;
      };
    };

    xdg = {
      mimeApps.enable = true;

      configFile."menus/applications.menu".source = ./applications.menu;
    };

    dconf.settings."ca/desrt/dconf-editor".show-warning = false;
  };
}
