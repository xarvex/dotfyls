{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.protonvpn;
in
{
  options.dotfyls.programs.protonvpn = {
    enable = lib.mkEnableOption "Proton VPN" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Proton VPN" { default = "protonvpn-gui"; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [
      ".cache/Proton"
      ".cert/nm-openvpn"
    ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile = {
      "Proton/app-config.json".source = ./app-config.json;
      "Proton/settings.json".source = ./settings.json;
    };
  };
}
