{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.programs.proton;
  cfg = cfg'.pass;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".config/Proton Pass" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
