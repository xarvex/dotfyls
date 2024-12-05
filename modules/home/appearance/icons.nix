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

    set =
      lib.mkOption {
        type = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the icon.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              description = "Package providing the icon.";
            };
          };
        };
        description = "Icon set used.";
      }
      // {
        default = {
          name = "Colloid-Red-Catppuccin-Dark";
          package = pkgs.colloid-icon-theme.override {
            schemeVariants = [ "catppuccin" ];
            colorVariants = [ "all" ];
          };
        };
      };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = [ (self.lib.getCfgPkg cfg.set) ]; };
}
