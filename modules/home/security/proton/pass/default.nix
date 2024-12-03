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
    dotfyls.file.".config/Proton Pass" = {
      mode = "0700";
      cache = true;
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
