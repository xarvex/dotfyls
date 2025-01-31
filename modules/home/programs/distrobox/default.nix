{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.programs.distrobox;
in
{
  options.dotfyls.programs.distrobox.enable = lib.mkEnableOption "Distrobox";

  config = lib.mkIf cfg.enable {
    dotfyls.programs.podman.enable = true;

    home.packages = with pkgs; [ distrobox ];

    xdg.configFile."distrobox/distrobox.conf".source = ./distrobox.conf;
  };
}
