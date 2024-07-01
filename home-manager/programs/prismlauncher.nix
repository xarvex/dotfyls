{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.prismlauncher.enable = lib.mkEnableOption "Prism Launcher" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.prismlauncher.enable {
    home.packages = with pkgs; [ (prismlauncher.override { withWaylandGLFW = true; }) ];

    dotfyls.persist.directories = [ ".local/share/PrismLauncher" ];
  };
}
