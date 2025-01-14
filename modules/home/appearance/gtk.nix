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
  options.dotfyls.appearance.gtk = {
    enable = lib.mkEnableOption "GTK" // {
      default = true;
    };

    theme = lib.mkOption rec {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "Colloid-Red-Dark-Catppuccin";
            description = "Name of the GTK theme.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            example = lib.literalExpression ''
              pkgs.colloid-gtk-theme.override {
                themeVariants = [ "all" ];
                colorVariants = [ "dark" ];
                tweaks = [
                  "catppuccin"
                  "black"
                  "normal"
                ];
              };

            '';
            description = "Package providing the GTK theme.";
          };
        };
      };
      default = {
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
      defaultText = lib.literalExpression ''
        {
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
        }
      '';
      example = defaultText;
      description = "GTK theme used.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/gtk-4.0/vulkan-pipeline-cache".cache = true;

    gtk = {
      enable = true;

      # TODO: Change dynamically with heuniform.
      theme = { inherit (cfg.theme) name package; };
      iconTheme = { inherit (cfg'.icons.theme) name package; };
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
