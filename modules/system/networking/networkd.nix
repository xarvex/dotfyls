{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.networkd;
in
{
  options.dotfyls.networking.networkd.enable = lib.mkEnableOption "systemd-networkd" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    networking.useNetworkd = true;

    boot.initrd.systemd.network.wait-online.enable = config.systemd.network.wait-online.enable;

    systemd.network = {
      wait-online.enable = !config.networking.networkmanager.enable;
      config.networkConfig.IPv6PrivacyExtensions = true;
    };
  };
}
