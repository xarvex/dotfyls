{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.distrobox;
in
{
  options.dotfyls.containers.distrobox.enable = lib.mkEnableOption "Distrobox";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.containers.podman.enable = true;

    home.packages = with pkgs; [ distrobox ];

    xdg.configFile."distrobox/distrobox.conf".source = ./distrobox.conf;
  };
}
