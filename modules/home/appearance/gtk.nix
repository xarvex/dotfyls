{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.gtk;
in
{
  options.dotfyls.appearance.gtk.enable = lib.mkEnableOption "GTK" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    gtk = {
      enable = true;

      theme = {
        # TODO: Change dynamically with heuniform.
        name = "Colloid-Red-Dark-Catppuccin";
        package = pkgs.colloid-gtk-theme.override {
          themeVariants = [ "all" ];
          colorVariants = [ "dark" ];
          tweaks = [
            "catppuccin"
            "black"
            "normal"
          ];
        };
      };
      iconTheme = {
        inherit (cfg'.icons.set) name package;
      };
      font = {
        name = "sans-serif";
        size = cfg'.systemFontSize;
      };

      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-error-bell = 0;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-error-bell = 0;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
    };
  };
}
