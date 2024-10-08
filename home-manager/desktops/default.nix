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
      ./gtk.nix
      ./qt.nix
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
    dotfyls.persist.directories = [
      ".local/share/applications"
      ".local/share/icons"
    ];

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

    xdg.mimeApps = {
      enable = true;

      # https://github.com/KDE/plasma-desktop/blob/master/kde-mimeapps.list
      defaultApplications = {
        # Audio
        "audio/aac" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/mpegurl" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/vnd.rn-realaudio" = "mpv.desktop";
        "audio/vorbis" = "mpv.desktop";
        "audio/x-flac" = "mpv.desktop";
        "audio/x-mp3" = "mpv.desktop";
        "audio/x-mpegurl" = "mpv.desktop";
        "audio/x-ms-wma" = "mpv.desktop";
        "audio/x-musepack" = "mpv.desktop";
        "audio/x-oggflac" = "mpv.desktop";
        "audio/x-pn-realaudio" = "mpv.desktop";
        "audio/x-scpls" = "mpv.desktop";
        "audio/x-speex" = "mpv.desktop";
        "audio/x-vorbis" = "mpv.desktop";
        "audio/x-vorbis+ogg" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";

        # File
        "inode/directory" = "nemo.desktop";

        # Image
        "image/avif" = "pix.desktop";
        "image/bmp" = "pix.desktop";
        "image/gif" = "pix.desktop";
        "image/heif" = "pix.desktop";
        "image/jpeg" = "pix.desktop";
        "image/jpg" = "pix.desktop";
        "image/jxl" = "pix.desktop";
        "image/png" = "pix.desktop";
        "image/svg+xml" = "pix.desktop";
        "image/tiff" = "pix.desktop";
        "image/webp" = "pix.desktop";
        "image/x-eps" = "pix.desktop";
        "image/x-icns" = "pix.desktop";
        "image/x-ico" = "pix.desktop";
        "image/x-portable-bitmap" = "pix.desktop";
        "image/x-portable-graymap" = "pix.desktop";
        "image/x-portable-pixmap" = "pix.desktop";
        "image/x-psd" = "pix.desktop";
        "image/x-tga" = "pix.desktop";
        "image/x-webp" = "pix.desktop";
        "image/x-xbitmap" = "pix.desktop";
        "image/x-xpixmap" = "pix.desktop";

        # PDF
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/vnd.djvu" = "org.pwmt.zathura.desktop";

        # Text
        "application/json" = "nvim.desktop";
        "application/x-docbook+xml" = "nvim.desktop";
        "application/x-ruby" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/x-yaml" = "nvim.desktop";
        "inode/x-empty" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "text/plain" = "nvim.desktop";
        "text/rhtml" = "nvim.desktop";
        "text/x-cmake" = "nvim.desktop";
        "text/x-java" = "nvim.desktop";
        "text/x-markdown" = "nvim.desktop";
        "text/x-python" = "nvim.desktop";
        "text/x-readme" = "nvim.desktop";
        "text/x-ruby" = "nvim.desktop";
        "text/x-tex" = "nvim.desktop";

        # Video
        "application/x-matroska" = "mpv.desktop";
        "video/3gp" = "mpv.desktop";
        "video/3gpp" = "mpv.desktop";
        "video/3gpp2" = "mpv.desktop";
        "video/avi" = "mpv.desktop";
        "video/divx" = "mpv.desktop";
        "video/dv" = "mpv.desktop";
        "video/fli" = "mpv.desktop";
        "video/flv" = "mpv.desktop";
        "video/mp2t" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mp4v-es" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/msvideo" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/vnd.divx" = "mpv.desktop";
        "video/vnd.mpegurl" = "mpv.desktop";
        "video/vnd.rn-realvideo" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/x-avi" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";
        "video/x-m4v" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-mpeg2" = "mpv.desktop";
        "video/x-ms-asf" = "mpv.desktop";
        "video/x-ms-wmv" = "mpv.desktop";
        "video/x-ms-wmx" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/x-ogm" = "mpv.desktop";
        "video/x-ogm+ogg" = "mpv.desktop";
        "video/x-theora" = "mpv.desktop";
        "video/x-theora+ogg" = "mpv.desktop";

        # Web
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
  };
}
