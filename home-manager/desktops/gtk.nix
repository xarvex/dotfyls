{ config, lib, ... }:

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
