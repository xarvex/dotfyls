{ config, lib, ... }:

# TODO: firewalls
{
  options.dotfyls.networking = {
    wireless = lib.mkEnableOption "wireless networking" // { default = true; };
  };

  config = lib.mkIf config.dotfyls.networking.wireless {
    networking = {
      # Pick only one of the below networking options.
      # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      networkmanager.enable = true; # Easiest to use and most distros use this by default.
    };

    dotfyls.persist.directories = [ "/etc/NetworkManager" ];
  };
}
