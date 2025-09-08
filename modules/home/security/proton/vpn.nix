{
  config,
  lib,
  osConfig ? null,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.vpn;

  jsonFormat = pkgs.formats.json { };
in
{
  options.dotfyls.security.proton.vpn = {
    enable = lib.mkEnableOption "Proton VPN" // {
      default = true;
    };

    customDNS = lib.mkOption {
      type = self.lib.listOrSingleton lib.types.str;
      default = lib.optionals (osConfig != null) osConfig.networking.nameservers;
      example = "127.0.0.1";
      description = "DNS servers to use through Proton VPN.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.networking.networkmanager = {
      enable = true;
      enableApplet = true;
    };

    home.packages = with pkgs; [ protonvpn-gui ];

    xdg.configFile = {
      "Proton/VPN/app-config.json".source = jsonFormat.generate "proton-vpn-app-config" {
        tray_pinned_servers = [ ];
        connect_at_app_startup = null;
        start_app_minimized = false;
      };
      "Proton/VPN/settings.json".source = jsonFormat.generate "proton-vpn-settings" {
        protocol = "wireguard";
        killswitch = 1;
        custom_dns = {
          enabled = cfg.customDNS != [ ];
          ip_list = map (ip: {
            inherit ip;
            enabled = true;
          }) cfg.customDNS;
        };
        ipv6 = config.dotfyls.networking.enableIPv6;
        anonymous_crash_reports = false;
        features = {
          netshield = if cfg.customDNS == [ ] then 2 else 0;
          moderate_nat = false;
          vpn_accelerator = true;
          port_forwarding = true;
        };
      };
    };

    wayland.windowManager.hyprland.settings.windowrule = [
      "size 400 600, class:${lib.escapeRegex ".protonvpn-app-wrapped"}, title:Proton VPN"
    ];
  };
}
