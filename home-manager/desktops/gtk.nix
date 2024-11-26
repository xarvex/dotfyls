{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.gtk;
in
{
  options.dotfyls.desktops.gtk.enable = lib.mkEnableOption "GTK" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      font = {
        inherit (config.dotfyls.fonts.sansSerif) name package;

        # TODO: Set via shared option.
        size = 11;
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
