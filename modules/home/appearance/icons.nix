{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.icons;
in
{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
  ];

  options.dotfyls.appearance.icons = {
    enable = lib.mkEnableOption "icons" // {
      default = config.dotfyls.desktops.enable;
    };

    theme = lib.mkOption rec {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "Colloid-Red-Catppuccin-Dark";
            description = "Name of the icon theme.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            example = lib.literalExpression ''
              pkgs.colloid-icon-theme.override {
                schemeVariants = [ "catppuccin" ];
                colorVariants = [ "all" ];
              }
            '';
            description = "Package providing the icon theme.";
          };
        };
      };
      default = {
        name = "Colloid-Red-Catppuccin-Dark";
        package = pkgs.colloid-icon-theme.override {
          schemeVariants = [ "catppuccin" ];
          colorVariants = [ "all" ];
        };
      };
      defaultText = lib.literalExpression ''
        {
          name = "Colloid-Red-Catppuccin-Dark";
          package = pkgs.colloid-icon-theme.override {
            schemeVariants = [ "catppuccin" ];
            colorVariants = [ "all" ];
          };
        }
      '';
      example = defaultText;
      description = "Icon theme used.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = [ (self.lib.getCfgPkg cfg.theme) ];
  };
}
