{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.qt;

  iniFormat = pkgs.formats.ini { };

  catppuccinAccents = [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];
in
{
  options.dotfyls.appearance.qt.enable = lib.mkEnableOption "Qt" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.desktops.wayland.sessionVariables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;

    home.packages = with pkgs; [
      qt5.qtsvg
      qt6.qtsvg

      qt5.qtwayland
      qt6.qtwayland

      # kde (6)
      kdePackages.kio
      kdePackages.plasma-integration
      kdePackages.systemsettings

      kdePackages.qqc2-desktop-style

      # kvantum
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum

      # qtct
      libsForQt5.qt5ct
      kdePackages.qt6ct
    ];

    qt = {
      enable = true;

      platformTheme.name = "kde6";
      style.name = "kvantum-dark";
    };

    xdg = {
      systemDirs.data = [
        "${
          pkgs.catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = catppuccinAccents;
          }
        }/share"
      ];

      configFile =
        let
          qtctConf = {
            Appearance = {
              custom_palette = true;
              icon_theme = cfg'.icons.name;
              standard_dialogs = "xdgdesktopportal";
              style = "kvantum-dark";
            };

            Interface = {
              activate_item_on_single_click = 1;
              buttonbox_layout = 2;
              cursor_flash_time = 1000;
              dialog_buttons_have_icons = 1;
              double_click_interval = 400;
              keyboard_scheme = 2;
              menus_have_icons = true;
              show_shortcuts_in_context_menus = true;
              toolbutton_style = 4;
              underline_shortcut = 1;
              wheel_scroll_lines = 3;
            };
          };

          defaultFont = "sans-serif,${toString cfg'.systemFontSize}";
        in
        {
          kdeglobals.source =
            pkgs.runCommand "kdeglobals"
              {
                nativeBuildInputs = with pkgs; [
                  coreutils
                  crudini
                ];

                package = pkgs.catppuccin-kde.override {
                  flavour = [ "mocha" ];
                  accents = [ "maroon" ];
                };
                theme = "CatppuccinMochaMaroon";
                config = lib.generators.toINI { } {
                  General = {
                    # TODO:
                    # AccentColor = R,G,B,A;
                    AllowKDEAppsToRememberWindowPositions = false;
                    TerminalApplication = self.lib.getCfgExe config.xdg.terminal-exec;
                  };

                  Icons.Theme = cfg'.icons.name;

                  KDE = {
                    LookAndFeelPackage = "Catppuccin-Mocha-Maroon";
                    widgetStyle = "kvantum-dark";
                  };
                };
                passAsFile = [ "config" ];
              }
              ''
                cp $package/share/color-schemes/$theme.colors $out

                chmod u+w $out
                substituteInPlace $out --replace-warn '[Colors:Header][Inactive]' '[Colors:Header:Inactive]'

                crudini --merge --ini-options nospace $out <$configPath

                substituteInPlace $out --replace-warn '[Colors:Header:Inactive]' '[Colors:Header][Inactive]'
                chmod u-w $out
              '';

          "Kvantum/kvantum.kvconfig".source = iniFormat.generate "kvantum-kvconfig" {
            # TODO: Change dynamically with heuniform.
            General.theme = "catppuccin-mocha-maroon";
          };

          "qt5ct/qt5ct.conf".source = iniFormat.generate "qt5ct-conf" (
            lib.recursiveUpdate qtctConf {
              Appearance.color_scheme_path = "${config.xdg.configHome}/qt5ct/style-colors.conf";

              Fonts = rec {
                fixed = ''"${defaultFont},-1,5,50,0,0,0,0,0,Regular"'';
                general = fixed;
              };
            }
          );
          "qt6ct/qt6ct.conf".source = iniFormat.generate "qt6ct-conf" (
            lib.recursiveUpdate qtctConf {
              Appearance.color_scheme_path = "${config.xdg.configHome}/qt6ct/style-colors.conf";

              Fonts = rec {
                fixed = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
                general = fixed;
              };
            }
          );
        }
        // (lib.mapAttrs' (accent: lib.nameValuePair "Kvantum/catppuccin-mocha-${accent}") (
          lib.genAttrs catppuccinAccents (accent: {
            source = "${
              pkgs.catppuccin-kvantum.override {
                inherit accent;
                variant = "mocha";
              }
            }/share/Kvantum/catppuccin-mocha-${accent}";
          })
        ));
    };
  };
}
