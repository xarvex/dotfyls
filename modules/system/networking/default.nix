{ config, lib, ... }:

let
  cfg = config.dotfyls.networking;
in
{
  imports = [
    ./bluetooth.nix
    ./dnscrypt.nix
    ./firewall.nix
    ./iwd.nix
    ./kernel.nix
    ./networkd.nix
    ./networkmanager.nix
  ];

  options.dotfyls.networking = {
    enable = lib.mkEnableOption "networking" // {
      default = true;
    };
    # TODO: Use where relevant.
    enableIPv4 = lib.mkEnableOption "IPv4" // {
      default = true;
    };
    enableIPv6 = lib.mkEnableOption "IPv6";
  };

  config = {
    dotfyls.file."/etc/ssl/certs" = lib.mkIf cfg.enable { cache = true; };

    networking = {
      inherit (cfg) enableIPv6;

      # Even with networking disabled, this must be set.
      # This is especially true for ZFS, and potentially other software.
      hostId = config.dotfyls.meta.id;
      hostName = config.dotfyls.meta.name;

      tempAddresses = "default";
      wireless.enable = false;
    };

    boot.kernelParams = lib.optional (!cfg.enableIPv6) "ipv6.disable=1";
  };
}
