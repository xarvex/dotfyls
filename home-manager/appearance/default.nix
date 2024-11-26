{ config, lib, ... }:

{
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
  ];

  options.dotfyls.appearance = {
    enable = lib.mkEnableOption "appearance" // {
      default = config.dotfyls.desktops.enable;
    };

    systemFontSize = lib.mkOption {
      type = lib.types.int;
      default = 11;
      example = 12;
      description = "Font size to use for system.";
    };
  };
}