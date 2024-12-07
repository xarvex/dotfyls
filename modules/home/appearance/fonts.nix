{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.appearance;
  cfg = cfg'.fonts;
in
{
  imports = [ self.homeManagerModules.appearance_fonts ];

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".cache/fontconfig".cache = true;

    fonts.fontconfig.enable = true;
  };
}
