{ config, lib, pkgs, ... }:

{
  options.dotfyls.fonts =
    let
      mkFontOption = name: lib.mkOption {
        type = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the font.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              description = "Package providing the font.";
            };
          };
        };
        description = "Font used for ${name}.";
      };
    in
    {
      enable = lib.mkEnableOption "fonts" // { default = true; };
      monospace = mkFontOption "monospace" // {
        default = {
          name = "Iosevka Term SS14 Extended";
          package = (pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; });
        };
      };
      emoji = mkFontOption "emoji" // {
        default = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
      };
    };

  config = let cfg = config.dotfyls.fonts; in lib.mkIf cfg.enable {
    home.packages = [
      cfg.monospace.package
      cfg.emoji.package
      (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [ cfg.monospace.name "Symbols Nerd Font" ];
        emoji = [ cfg.emoji.name ];
      };
    };
  };
}
