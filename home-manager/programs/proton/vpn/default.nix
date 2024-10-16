{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.programs.proton;
  cfg = cfg'.vpn;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [ ".cert/nm-openvpn" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile = {
      "Proton/VPN/app-config.json".source = ./app-config.json;
      "Proton/VPN/settings.json".source = ./settings.json;
    };
  };
}
