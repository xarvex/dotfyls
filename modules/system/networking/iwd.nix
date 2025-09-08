{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.iwd;
in
{
  options.dotfyls.networking.iwd.enable = lib.mkEnableOption "iNet wireless daemon" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file."/var/lib/iwd" = {
      mode = "0700";
      persist = true;
    };

    networking = {
      wireless.iwd = {
        enable = true;

        settings = {
          General = {
            AddressRandomization = "network";
            AddressRandomizationRange = "full";
          };
          Network.EnableIPv6 = cfg'.enableIPv6;
        };
      };
      networkmanager.wifi.backend = "iwd";
    };
  };
}
