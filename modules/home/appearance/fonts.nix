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

      serif = mkFontOption "serif" // {
        default = {
          name = "Libertinus Serif";
          package = pkgs.libertinus;
        };
      };
      sansSerif = mkFontOption "sans serif" // {
        default = {
          name = "Geist";
          package = pkgs.geist-font;
        };
      };
      monospace = mkFontOption "monospace" // {
        default = {
          name = "Iosevka Term SS14 Extended";
          package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; };
        };
      };
      multi-language = mkFontOption "multi-language" // {
        default = {
          name = "Noto Sans";
          package = pkgs.symlinkJoin {
            inherit (pkgs.noto-fonts) name meta;

            paths = [
              pkgs.noto-fonts
              pkgs.noto-fonts-cjk-sans
              pkgs.noto-fonts-cjk-serif
            ];
          };
        };
      };
      emoji = mkFontOption "emoji" // {
        default = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-emoji;
        };
      };
      symbols = mkFontOption "symbols" // {
        default = {
          name = "Material Symbols";
          package = pkgs.material-symbols;
        };
      };
      nerdfonts = mkFontOption "nerdfonts" // {
        default = {
          name = "Symbols Nerd Font";
          package = pkgs.nerd-fonts.symbols-only;
        };
      };
    };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/fontconfig".cache = true;

    home.packages = [
      (self.lib.getCfgPkg cfg.serif)
      (self.lib.getCfgPkg cfg.sansSerif)
      (self.lib.getCfgPkg cfg.monospace)
      (self.lib.getCfgPkg cfg.multi-language)
      (self.lib.getCfgPkg cfg.emoji)
      (self.lib.getCfgPkg cfg.symbols)
      (self.lib.getCfgPkg cfg.nerdfonts)
    ];

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        serif = with cfg; [
          serif.name
          nerdfonts.name
          symbols.name
          emoji.name
        ];
        sansSerif = with cfg; [
          sansSerif.name
          nerdfonts.name
          symbols.name
          emoji.name
        ];
        monospace = with cfg; [
          monospace.name
          "${nerdfonts.name} Mono"
          symbols.name
          emoji.name
        ];
        emoji = with cfg; [
          emoji.name
          symbols.name
        ];
      };
    };
  };
}
