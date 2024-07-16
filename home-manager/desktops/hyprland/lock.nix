{ config, lib, ... }:

lib.mkIf (config.dotfyls.desktops.enable && config.dotfyls.desktops.desktops.hyprland.enable) {
  programs.hyprlock = {
    enable = true;
    # TODO: theme
  };
}
