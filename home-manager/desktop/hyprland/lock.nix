{ config, lib, ... }:

lib.mkIf config.custom.desktop.hyprland.enable {
  programs.hyprlock = {
    enable = true;
    # TODO: theme
  };
}
