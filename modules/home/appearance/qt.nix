{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.qt;
in
{
  options.dotfyls.appearance.qt = {
    enable = lib.mkEnableOption "Qt" // {
      default = true;
    };

    theme = lib.mkOption rec {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "catppuccin-mocha-maroon";
            description = "Name of the Qt Kvantum theme.";
          };
          source = lib.mkOption {
            type = lib.types.path;
            example = lib.literalExpression ''
              "''${pkgs.catppuccin-kvantum.src}/themes"
            '';
            description = "Source providing the Qt Kvantum theme.";
          };
        };
      };
      default = {
        name = "catppuccin-mocha-maroon";
        source = "${pkgs.catppuccin-kvantum.src}/themes";
      };
      defaultText = lib.literalExpression ''
        {
          name = "catppuccin-mocha-maroon";
          source = "''${pkgs.catppuccin-kvantum.src}/themes";
        }
      '';
      example = defaultText;
      description = "Qt Kvantum theme used.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.desktops.wayland.sessionVariables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

    home.packages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qtwayland
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
      qt6Packages.qtwayland

      libsForQt5.qt5.qtsvg
      kdePackages.qtsvg
    ];

    qt = {
      enable = true;

      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile =
      let
        qtctConf = {
          Appearance = {
            custom_palette = false;
            icon_theme = cfg'.icons.theme.name;
            standard_dialogs = "xdgdesktopportal";
            style = "kvantum";
          };
        };

        defaultFont = "sans-serif,${toString cfg'.systemFontSize}";
      in
      {
        "kdeglobals".text = lib.generators.toINI { } {
          Icons.Theme = cfg'.icons.theme.name;
        };

        "Kvantum" = {
          inherit (cfg.theme) source;
          recursive = true;
        };
        "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } {
          # TODO: Change dynamically with heuniform.
          General.theme = cfg.theme.name;
        };

        "qt5ct/qt5ct.conf".text = lib.generators.toINI { } (
          qtctConf
          // {
            Fonts = rec {
              fixed = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
              general = fixed;
            };
          }
        );
        "qt6ct/qt6ct.conf".text = lib.generators.toINI { } (
          qtctConf
          // {
            Fonts = rec {
              fixed = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
              general = fixed;
            };
          }
        );
      };
  };
}
