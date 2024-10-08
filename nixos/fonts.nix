{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.fonts;
  hmCfg = config.hm.dotfyls.fonts;
in
{
  options.dotfyls.fonts =
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
        default = hmCfg.enable;
      };
      monospace = mkFontOption "monospace" // {
        default = hmCfg.monospace;
      };
      emoji = mkFontOption "emoji" // {
        default = hmCfg.emoji;
      };
      symbols = mkFontOption "nerdfonts" // {
        default = hmCfg.symbols;
      };
    };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = [
        (self.lib.getCfgPkg cfg.monospace)
        (self.lib.getCfgPkg cfg.emoji)
        (self.lib.getCfgPkg cfg.symbols)
      ];

      fontconfig.defaultFonts = {
        monospace = with cfg; [
          monospace.name
          symbols.name
        ];
        emoji = with cfg; [ emoji.name ];
      };
    };
  };
}
