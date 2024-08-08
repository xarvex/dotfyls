{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.prismlauncher;
in
{
  options.dotfyls.programs.prismlauncher = {
    enable = lib.mkEnableOption "Prism Launcher" // { default = config.dotfyls.desktops.enable; };
    package = lib.mkPackageOption pkgs "Prism Launcher" { default = "prismlauncher"; };
    finalPackage = self.lib.mkFinalPackageOption "Prism Launcher";
  };

  config = lib.mkIf cfg.enable {
    dotfyls.programs.prismlauncher.finalPackage = (cfg.package.override { withWaylandGLFW = true; });

    home.packages = with cfg; [ finalPackage ];

    dotfyls.persist.directories = [ ".local/share/PrismLauncher" ];
  };
}
