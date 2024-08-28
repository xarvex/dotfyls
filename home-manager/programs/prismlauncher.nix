{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.prismlauncher;
in
{
  options.dotfyls.programs.prismlauncher = {
    enable = lib.mkEnableOption "Prism Launcher" // { default = config.dotfyls.desktops.enable; };
    package = lib.mkPackageOption pkgs "Prism Launcher" { default = "prismlauncher"; };
    finalPackage = self.lib.mkFinalPackageOption "Prism Launcher"
      // { default = cfg.package.override { withWaylandGLFW = true; }; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/share/PrismLauncher" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
