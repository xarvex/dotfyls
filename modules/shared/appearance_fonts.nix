system:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.fonts;

  mkFont = name: package: { inherit name package; };

  serif = mkFont "Libertinus Serif" pkgs.libertinus;
  sans-serif = mkFont "Geist" pkgs.geist-font;
  monospace = mkFont "Iosevka Term SS14 Extended" (
    pkgs.iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; }
  );
  multi-language = mkFont "Noto Sans" (
    with pkgs;
    (symlinkJoin {
      inherit (noto-fonts) name meta;

      paths = [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
    })
  );
  emoji = mkFont "Noto Color Emoji" pkgs.noto-fonts-emoji;
  symbols = mkFont "Material Symbols" pkgs.material-symbols;
  nerd-fonts = mkFont "Symbols Nerd Font" pkgs.nerd-fonts.symbols-only;
in
{
  options.dotfyls.appearance.fonts.enable = lib.mkEnableOption "fonts" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) (
    lib.mkMerge [
      {
        fonts.fontconfig.defaultFonts = {
          serif = [
            serif.name
            nerd-fonts.name
            symbols.name
            emoji.name
          ];
          sansSerif = [
            sans-serif.name
            nerd-fonts.name
            symbols.name
            emoji.name
          ];
          monospace = [
            monospace.name
            "${nerd-fonts.name} Mono"
            symbols.name
            emoji.name
          ];
          emoji = [
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
          serif.package
          sans-serif.package
          monospace.package
          multi-language.package
          emoji.package
          symbols.package
          nerd-fonts.package
        ]
      )
    ]
  );
}
