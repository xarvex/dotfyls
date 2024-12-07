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
    theme =
      lib.mkOption {
        type = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              example = "phinger-cursors-dark";
              description = "Name of the cursor theme.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              example = lib.literalExpression "pkgs.phinger-cursors";
              description = "Package providing the cursor theme.";
            };
          };
        };
        description = "Cursor theme used.";
      }
      // rec {
        default = {
          name = "phinger-cursors-dark";
          package = pkgs.phinger-cursors;
        };
        defaultText = lib.literalExpression ''
          {
            name = "phinger-cursors-dark";
            package = pkgs.phinger-cursors;
          }
        '';
        example = defaultText;
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
        inherit (cfg.theme) name package;
      };
    };
  };
}
