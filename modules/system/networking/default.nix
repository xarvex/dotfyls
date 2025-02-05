{ lib, ... }:

{
  imports = [
    ./bluetooth.nix
    ./dns.nix
    ./firewall.nix
    ./manager.nix
  ];

  options.dotfyls.networking.enable = lib.mkEnableOption "networking" // {
    default = true;
  };
}
