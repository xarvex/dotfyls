{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.qt;
in
{
  options.dotfyls.desktops.qt.enable = lib.mkEnableOption "Qt" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qtwayland
      qt6Packages.qt6ct
      qt6Packages.qtstyleplugin-kvantum
      qt6Packages.qtwayland
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
            icon_theme = config.gtk.iconTheme.name;
            standard_dialogs = "xdgdesktopportal";
            style = "kvantum";
          };
        };

        # TODO: Set via shared option.
        defaultFont = "${config.dotfyls.fonts.sansSerif.name},11";
      in
      {
        "Kvantum" = {
          source = "${pkgs.catppuccin-kvantum.src}/themes";
          recursive = true;
        };
        "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } {
          # TODO: Change dynamically with heuniform.
          General.theme = "catppuccin-mocha-maroon";
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
