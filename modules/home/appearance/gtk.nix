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
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".cache/gtk-4.0/vulkan-pipeline-cache".cache = true;
      ".cache/gstreamer-1.0".cache = true;
    };

    gtk =
      let
        common = {
          gtk-application-prefer-dark-theme = 1;
          gtk-error-bell = 0;
        };
      in
      {
        enable = true;

        # TODO: Change dynamically with heuniform.
        theme = {
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
        iconTheme = { inherit (cfg'.icons) name package; };
        font = {
          name = "sans-serif";
          size = cfg'.systemFontSize;
        };

        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        gtk3.extraConfig = common;
        gtk4.extraConfig = common;
      };

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
    };
  };
}
