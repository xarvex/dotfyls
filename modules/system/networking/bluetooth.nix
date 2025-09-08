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

    onlyHighQualityAudio =
      lib.mkEnableOption "disabling lower quality audio codecs, like for headsets"
      // {
        default = true;
      };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file."/var/lib/bluetooth" = {
      mode = "0700";
      persist = true;
    };

    services = {
      blueman.enable = cfg.blueman.enable;

      pipewire.wireplumber.extraConfig."10-bluetooth-policy" = {
        "wireplumber.settings"."bluetooth.autoswitch-to-headset-profile" = !cfg.onlyHighQualityAudio;
        "monitor.bluez.properties" = {
          "bluez5.a2dp.ldac.quality" = "hq";
          "bluez5.roles" = lib.mkIf cfg.onlyHighQualityAudio [
            "a2dp_sink"
            "a2dp_source"
            "bap_sink"
            "bap_source"
          ];
        };
      };
    };

    hardware.bluetooth.enable = true;
  };
}
