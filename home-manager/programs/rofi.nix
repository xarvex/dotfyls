{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.rofi.enable = lib.mkEnableOption "Rofi" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
