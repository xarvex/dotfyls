# TODO: Obverse what other rules need adding.
{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.firewall;
in
{
  options.dotfyls.networking.firewall = {
    enable = lib.mkEnableOption "firewall" // {
      default = true;
    };

    allowPing = lib.mkEnableOption "allow IPv4 pinging" // {
      default = config.dotfyls.meta.machine.isServer;
    };
  };

  config = {
    networking = {
      firewall = {
        inherit (cfg) enable;

        inherit (cfg) allowPing;
      };
      nftables.enable = cfg.enable;
    };
  };
}
