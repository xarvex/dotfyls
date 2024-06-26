{ config, lib, pkgs, ... }:

{
  options.custom.programs.rofi.enable = lib.mkEnableOption "Enable Rofi (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
