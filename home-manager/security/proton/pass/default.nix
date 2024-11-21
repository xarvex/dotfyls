{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.pass;
in
{
  options.dotfyls.security.proton.pass = {
    enable = lib.mkEnableOption "Proton Pass" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "Proton Pass" { default = "proton-pass"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".config/Proton Pass" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
