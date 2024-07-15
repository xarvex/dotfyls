{ lib, ... }:

{
  imports = [
    ./hyprland
  ];

  options.dotfyls.desktop = {
    displays = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            example = "eDP-1";
            description = "Name of the display.";
          };
          width = lib.mkOption {
            type = lib.types.int;
            example = 1920;
            description = "Width of the display.";
          };
          height = lib.mkOption {
            type = lib.types.int;
            example = 1080;
            description = "Height of the display.";
          };
          refresh = lib.mkOption {
            type = lib.types.int;
            default = 60;
            example = 60;
            description = "Refresh of the display.";
          };
          position = lib.mkOption {
            type = lib.types.str;
            default = "0x0";
            description = "Position of the display.";
          };
          vertical = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Vertical state of the display.";
          };
        };
      });
      default = [ ];
      description = "Configuration of displays.";
    };
  };
}
