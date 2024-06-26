{ config, lib, pkgs, ... }:

{
  options.custom.programs.prismlauncher.enable = lib.mkEnableOption "Enable Prism Launcher (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.prismlauncher.enable {
    home.packages = with pkgs; [ (prismlauncher.override { withWaylandGLFW = true; }) ];

    custom.persist.directories = [ ".local/share/PrismLauncher" ];
  };
}
