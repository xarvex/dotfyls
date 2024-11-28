{ config, lib, ... }:

# TODO: firewalls
let
  cfg = config.dotfyls.networking;
in
{
  options.dotfyls.networking = {
    wireless = lib.mkEnableOption "wireless networking" // {
      default = true;
    };
    bluetooth = {
      enable = lib.mkEnableOption "Bluetooth networking" // {
        default = true;
      };
      blueman.enable = lib.mkEnableOption "Blueman" // {
        default = config.dotfyls.desktops.enable;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.wireless {
      dotfyls.files = {
        persistDirectories = [ "/etc/NetworkManager" ];
        cacheDirectories = [ "/var/lib/NetworkManager" ];
      };

      networking.networkmanager.enable = true;
    })

    (lib.mkIf cfg.bluetooth.enable {
      dotfyls.files.persistDirectories = [ "/var/lib/bluetooth" ];

      services.blueman.enable = lib.mkIf cfg.bluetooth.blueman.enable true;

      hardware.bluetooth.enable = true;
    })
  ];
}
