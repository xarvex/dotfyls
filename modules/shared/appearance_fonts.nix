system:
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
  hmCfg = config.hm.dotfyls.appearance.fonts;
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
                example = "Iosevka Term SS14 Extended";
                description = "Name of the font.";
              };
              package = lib.mkOption {
                type = lib.types.package;
                example = lib.literalExpression ''
                  pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; }
                '';
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

      serif = mkFontOption "serif" // rec {
        default =
          if system then
            hmCfg.serif
          else
            {
              name = "Libertinus Serif";
              package = pkgs.libertinus;
            };
        defaultText = lib.literalExpression ''
          {
            name = "Libertinus Serif";
            package = pkgs.libertinus;
          }
        '';
        example = defaultText;
      };
      sansSerif = mkFontOption "sans serif" // rec {
        default =
          if system then
            hmCfg.sansSerif
          else
            {
              name = "Geist";
              package = pkgs.geist-font;
            };
        defaultText = lib.literalExpression ''
          {
            name = "Geist";
            package = pkgs.geist-font;
          }
        '';
        example = defaultText;
      };
      monospace = mkFontOption "monospace" // rec {
        default =
          if system then
            hmCfg.monospace
          else
            {
              name = "Iosevka Term SS14 Extended";
              package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; };
            };
        defaultText = lib.literalExpression ''
          {
            name = "Iosevka Term SS14 Extended";
            package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; };
          }
        '';
        example = defaultText;
      };
      multi-language = mkFontOption "multi-language" // rec {
        default =
          if system then
            hmCfg.multi-language
          else
            {
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
        defaultText = lib.literalExpression ''
          {
            name = "Noto Sans";
            package = pkgs.symlinkJoin {
              inherit (pkgs.noto-fonts) name meta;

              paths = [
                pkgs.noto-fonts
                pkgs.noto-fonts-cjk-sans
                pkgs.noto-fonts-cjk-serif
              ];
            };
          }
        '';
        example = defaultText;
      };
      emoji = mkFontOption "emoji" // rec {
        default =
          if system then
            hmCfg.emoji
          else
            {
              name = "Noto Color Emoji";
              package = pkgs.noto-fonts-emoji;
            };
        defaultText = lib.literalExpression ''
          {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-emoji;
          }
        '';
        example = defaultText;
      };
      symbols = mkFontOption "symbols" // rec {
        default =
          if system then
            hmCfg.symbols
          else
            {
              name = "Material Symbols";
              package = pkgs.material-symbols;
            };
        defaultText = lib.literalExpression ''
          {
            name = "Material Symbols";
            package = pkgs.material-symbols;
          }
        '';
        example = defaultText;
      };
      nerdfonts = mkFontOption "nerdfonts" // rec {
        default =
          if system then
            hmCfg.nerdfonts
          else
            {
              name = "Symbols Nerd Font";
              package = pkgs.nerd-fonts.symbols-only;
            };
        defaultText = ''
          {
            name = "Symbols Nerd Font";
            package = pkgs.nerd-fonts.symbols-only;
          }
        '';
        example = defaultText;
      };
    };

  config = lib.mkIf (cfg'.enable && cfg.enable) (
    lib.mkMerge [
      {
        fonts.fontconfig.defaultFonts = {
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
      }

      (lib.setAttrByPath
        [
          (if system then "fonts" else "home")
          "packages"
        ]
        [
          (self.lib.getCfgPkg cfg.serif)
          (self.lib.getCfgPkg cfg.sansSerif)
          (self.lib.getCfgPkg cfg.monospace)
          (self.lib.getCfgPkg cfg.multi-language)
          (self.lib.getCfgPkg cfg.emoji)
          (self.lib.getCfgPkg cfg.symbols)
          (self.lib.getCfgPkg cfg.nerdfonts)
        ]
      )
    ]
  );
}
