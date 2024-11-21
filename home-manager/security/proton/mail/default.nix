{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.mail;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".config/Proton Mail" ];

    home.packages = [ (lib.hiPrio (self.lib.getCfgPkg cfg)) ];
  };
}
