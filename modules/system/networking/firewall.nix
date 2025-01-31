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
    allowPing = lib.mkEnableOption "allow IPv4 pinging";
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { networking.firewall.allowPing = cfg.allowPing; };
}
