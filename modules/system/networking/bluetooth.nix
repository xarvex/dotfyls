{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.bluetooth;
in
{
  options.dotfyls.networking.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth" // {
      default = config.dotfyls.desktops.enable;
    };
    blueman.enable = lib.mkEnableOption "Blueman" // {
      default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file."/var/lib/bluetooth" = {
      mode = "0700";
      persist = true;
    };

    services.blueman.enable = cfg.blueman.enable;

    hardware.bluetooth.enable = true;
  };
}
