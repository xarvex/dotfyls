{
  lib,
  osConfig ? null,
  ...
}:

let
  osCfg = if osConfig == null then null else osConfig.dotfyls.networking;
in
{
  imports = [ ./networkmanager.nix ];

  options.dotfyls.networking = {
    enable = lib.mkEnableOption "networking" // {
      default = osCfg == null || osCfg.enable;
    };
    # TODO: Use where relevant.
    enableIPv4 = lib.mkEnableOption "IPv4" // {
      default = osCfg == null || osCfg.enableIPv4;
    };
    enableIPv6 = lib.mkEnableOption "IPv6" // {
      default = osCfg.enableIPv6;
    };
  };
}
