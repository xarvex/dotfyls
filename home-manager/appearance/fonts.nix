{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.fonts;
in
{
  options.dotfyls.appearance.fonts =
    let
      mkFontOption =
        name:
        lib.mkOption {
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
      enable = lib.mkEnableOption "fonts" // {
        default = config.dotfyls.desktops.enable;
      };

      sansSerif = mkFontOption "sans serif" // {
        default = {
          name = "Geist Regular";
          package = pkgs.geist-font;
        };
      };
      monospace = mkFontOption "monospace" // {
        default = {
          name = "Iosevka Term SS14 Extended";
          package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; };
        };
      };
      emoji = mkFontOption "emoji" // {
        default = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
      };
      symbols = mkFontOption "nerdfonts" // {
        default = {
          name = "Symbols Nerd Font";
          package = pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
        };
      };
    };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".cache/fontconfig" ];

    home.packages = [
      (self.lib.getCfgPkg cfg.sansSerif)
      (self.lib.getCfgPkg cfg.monospace)
      (self.lib.getCfgPkg cfg.emoji)
      (self.lib.getCfgPkg cfg.symbols)
    ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        sansSerif = with cfg; [ sansSerif.name ];
        monospace = with cfg; [
          monospace.name
          symbols.name
        ];
        emoji = with cfg; [ emoji.name ];
      };
    };
  };
}
