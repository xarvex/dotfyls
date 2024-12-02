{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.vpn;
in
{
  options.dotfyls.security.proton.vpn = {
    enable = lib.mkEnableOption "Proton VPN" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "Proton VPN" { default = "protonvpn-gui"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile = {
      "Proton/VPN/app-config.json".source = ./app-config.json;
      "Proton/VPN/settings.json".source = ./settings.json;
    };
  };
}
