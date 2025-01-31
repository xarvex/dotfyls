{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.vpn;
in
{
  options.dotfyls.security.proton.vpn.enable = lib.mkEnableOption "Proton VPN" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = with pkgs; [ protonvpn-gui ];

    xdg.configFile = {
      "Proton/VPN/app-config.json".source = ./app-config.json;
      "Proton/VPN/settings.json".source = ./settings.json;
    };
  };
}
