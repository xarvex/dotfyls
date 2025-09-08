{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.dnscrypt;
in
{
  options.dotfyls.networking.dnscrypt.enable = lib.mkEnableOption "DNSCrypt" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services = {
      resolved = {
        fallbackDns = lib.mkForce [ ];
        domains = lib.mkForce [ "~." ];
        llmnr = lib.mkForce "false";
        dnssec = lib.mkForce "false";
        dnsovertls = lib.mkForce "false";
        extraConfig = lib.mkForce ''
          Cache=false
          DNSStubListener=false
        '';
      };
      dnscrypt-proxy2 = {
        enable = true;

        settings = {
          # Server Selection
          ipv4_servers = cfg'.enableIPv4;
          ipv6_servers = cfg'.enableIPv6;
          dnscrypt_servers = true;
          doh_servers = false;
          odoh_servers = true;
          require_dnssec = true;
          require_nolog = true;
          require_nofilter = true;

          # Connection Settings
          http3 = true;

          # Filters
          block_ipv6 = !cfg'.enableIPv6;

          # Anonymized DNS
          anonymized_dns = {
            routes = [
              {
                server_name = "*";
                via = [ "*" ];
              }
            ];
            skip_incompatible = true;
          };
        };
      };
    };

    networking = {
      nameservers = lib.mkForce ([ "127.0.0.1" ] ++ lib.optional cfg'.enableIPv6 "::1");
      search = lib.mkForce [ "." ];

      dhcpcd.extraConfig = lib.mkForce "nohook resolv.conf";
      wireless.iwd.settings.Network.NameResolvingService = lib.mkForce "none";
      networkmanager = {
        dns = lib.mkForce "none";
        settings.main.systemd-resolved = false;
      };
    };
  };
}
