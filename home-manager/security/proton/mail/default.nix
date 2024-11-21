{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.mail;
in
{
  options.dotfyls.security.proton.mail = {
    enable = lib.mkEnableOption "Proton Mail" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "Proton Mail" { default = "protonmail-desktop"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".config/Proton Mail" ];

    home.packages = [ (lib.hiPrio (self.lib.getCfgPkg cfg)) ];
  };
}
