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
  imports = [ self.nixosModules.appearance_fonts ];

  config = lib.mkIf (cfg'.enable && cfg.enable) { fonts.enableDefaultPackages = false; };
}
