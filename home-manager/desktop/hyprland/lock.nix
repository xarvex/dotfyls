{ config, lib, ... }:

lib.mkIf config.dotfyls.desktop.hyprland.enable {
  programs.hyprlock = {
    enable = true;
    # TODO: theme
  };
}
