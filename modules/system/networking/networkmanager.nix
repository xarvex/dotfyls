{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.networkmanager;
in
{
  options.dotfyls.networking.networkmanager.enable = lib.mkEnableOption "NetworkManager" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      "/etc/NetworkManager".persist = true;
      "/var/lib/NetworkManager" = {
        mode = "0700";
        cache = true;
      };
    };

    networking.networkmanager = {
      enable = true;

      ethernet.macAddress = "stable";
      wifi.macAddress = "stable";
      connectionConfig."ipv6.ip6-privacy" = 2;
    };

    users.groups.networkmanager.members = [ config.dotfyls.meta.user ];
  };
}
