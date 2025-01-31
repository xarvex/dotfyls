{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.cursor;
in
{
  options.dotfyls.appearance.cursor = {
    enable = lib.mkEnableOption "cursor" // {
      default = config.dotfyls.desktops.enable;
    };

    size = lib.mkOption {
      type = lib.types.int;
      default = 24;
      example = 32;
      description = "Size of the cursor.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home = {
      sessionVariables = {
        XCURSOR_THEME = config.home.pointerCursor.name;
        XCURSOR_SIZE = config.home.pointerCursor.size;
      };

      pointerCursor = {
        x11.enable = true;
        gtk.enable = true;

        inherit (cfg) size;
        name = "phinger-cursors-dark";
        package = pkgs.phinger-cursors;
      };
    };
  };
}
