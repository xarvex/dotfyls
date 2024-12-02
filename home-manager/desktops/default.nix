{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops;

  desktops = {
    hyprland =
      let
        hCfg = cfg.desktops.hyprland;
      in
      {
        name = "Hyprland";
        idler = {
          default = "hypridle";
          choices = [
            "hypridle"
            "swayidle"
          ];
        };
        locker = {
          default = "hyprlock";
          choices = [
            "hyprlock"
            "swaylock"
          ];
        };
        specialArgs =
          let
            mkDisplayCommand =
              state:
              pkgs.dotfyls.mkCommand {
                runtimeInputs = [ (self.lib.getCfgPkg hCfg) ];
                text = "hyprctl dispatch dpms ${state}";
              };
          in
          {
            startCommand.default = self.lib.getCfgPkg hCfg;
            idle.displays = {
              onCommand.default = mkDisplayCommand "on";
              offCommand.default = mkDisplayCommand "off";
            };
          };
      };
  };
in
{
  imports =
    [
      ./hyprland
      ./idles
      ./locks

      (self.lib.mkSelectorModule
        [
          "dotfyls"
          "desktops"
        ]
        {
          name = "default";
          default = "hyprland";
          description = "Default desktop to use.";
        }
        (builtins.mapAttrs (_: desktop: desktop.name) desktops)
      )

      (self.lib.mkCommonModules
        [
          "dotfyls"
          "desktops"
          "desktops"
        ]
        (desktop: _: {
          sessionName = lib.mkOption {
            type = lib.types.str;
            default = desktop.name;
            description = "XDG desktop session name for ${desktop.name}.";
          };
          startCommand = self.lib.mkCommandOption "start ${desktop.name}";

          idle = {
            enable = lib.mkEnableOption "${desktop.name} idle" // {
              default = true;
            };
            displays = {
              enable = lib.mkEnableOption "${desktop.name} display idle" // {
                default = true;
              };
              onCommand = self.lib.mkCommandOption "idle displays on";
              offCommand = self.lib.mkCommandOption "idle displays off";
            };
            suspend.enable = lib.mkEnableOption "${desktop.name} suspend idle" // {
              default = true;
            };
          };
          lock.enable = lib.mkEnableOption "${desktop.name} lock" // {
            default = true;
          };
        })
        desktops
      )
    ]
    ++ builtins.attrValues (
      builtins.mapAttrs (
        module: desktop:
        self.lib.mkSelectorModule'
          [
            "dotfyls"
            "desktops"
            "idles"
            "idles"
          ]
          [
            "dotfyls"
            "desktops"
            "desktops"
            module
            "idle"
          ]
          {
            inherit (desktop.idler) default;

            name = "provider";
            description = "Idler to use for ${desktop.name}.";
          }
          desktop.idler.choices
      ) desktops
    )
    ++ builtins.attrValues (
      builtins.mapAttrs (
        module: desktop:
        self.lib.mkSelectorModule'
          [
            "dotfyls"
            "desktops"
            "locks"
            "locks"
          ]
          [
            "dotfyls"
            "desktops"
            "desktops"
            module
            "lock"
          ]
          {
            inherit (desktop.locker) default;

            name = "provider";
            description = "Locker to use for ${desktop.name}.";
          }
          desktop.locker.choices
      ) desktops
    );

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // {
      default = true;
    };
    startCommand = self.lib.mkCommandOption "start default desktop" // {
      default = cfg.selected.startCommand;
    };

    wayland.sessionVariables = lib.mkOption {
      type = with lib.types; attrsOf (either int str);
      default = {
        EGL_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11,*";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland,x11,windows";
        CLUTTER_BACKEND = "wayland";

        NIXOS_OZONE_WL = 1;
        MOZ_ENABLE_WAYLAND = 1;

        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      };
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
    dotfyls.files = {
      ".local/share/applications" = {
        mode = "0700";
        persist = true;
      };
      ".local/share/icons".persist = true;
    };

    home = {
      sessionVariables = {
        XCURSOR_THEME = config.home.pointerCursor.name;
        XCURSOR_SIZE = config.home.pointerCursor.size;
      };

      pointerCursor = {
        x11.enable = true;
        gtk.enable = true;

        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
      };
    };
  };
}
