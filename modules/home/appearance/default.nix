{ config, lib, ... }:

let
  cfg = config.dotfyls.appearance;
in
{
  imports = [
    ./cursor.nix
    ./fonts.nix
    ./gtk.nix
    ./icons.nix
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

  config = lib.mkIf cfg.enable {
    dconf.settings."org/freedesktop/appearance" = {
      # TODO:
      # accent-color = tuple;
      color-scheme = 1;
    };
  };
}
