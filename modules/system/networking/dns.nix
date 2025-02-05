{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.dns;
in
{
  options.dotfyls.networking.dns = {
    enable = lib.mkEnableOption "DNS" // {
      default = true;
    };
    ipv6 = lib.mkEnableOption "IPv6";
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.dnscrypt-proxy2 = {
      enable = true;

      settings = {
        ipv6_servers = cfg.ipv6;
        block_ipv6 = !cfg.ipv6;

        require_dnssec = true;
        require_nofilter = true;
        require_nolog = true;
      };
    };

    networking = {
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";
    };
  };
}
