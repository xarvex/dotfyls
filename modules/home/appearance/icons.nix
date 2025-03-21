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
  options.dotfyls.appearance.icons = {
    enable = lib.mkEnableOption "icons" // {
      default = config.dotfyls.desktops.enable;
    };

    name = lib.mkOption {
      internal = true;
      readOnly = true;
      type = lib.types.str;
      default = "Colloid-Red-Catppuccin-Dark";
    };
    package = self.lib.mkStaticPackageOption (
      pkgs.colloid-icon-theme.override {
        schemeVariants = [ "catppuccin" ];
        colorVariants = [ "all" ];
      }
    );
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = [ cfg.package ]; };
}
