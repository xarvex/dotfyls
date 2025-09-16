{
  dotfyls = {
    browsers.chromium.enable = true;

    desktops.displays = [
      {
        connector = "eDP-1";
        width = 1920;
        height = 1200;
        refresh = 60;
        scale = 1.3333;
        touchscreen = true;
        workspaces = [
          7
          8
          9
          10
        ];
      }
      {
        make = "Lenovo Group Limited";
        model = "Q24i-1L";
        width = 1920;
        height = 1080;
        refresh = 75;
        position = "-1920x0";
        workspaces = [
          1
          2
          3
          4
          5
          6
        ];
      }
    ];

    management = {
      image.supportRPI = true;
      solaar = {
        enable = true;
        deviceConfig = ./solaar/config.yaml;
      };
    };

    # See: https://gitlab.freedesktop.org/pipewire/wireplumber/-/issues/634#note_2444019
    # See: https://wiki.archlinux.org/title/Bluetooth_headset#Disable_PipeWire_HSP/HFP_profile
    media.pipewire.wireplumber.extraConfig."90-sony-wh-1000xm3"."monitor.bluez.rules" = [
      {
        matches = [
          {
            "device.name" = "~bluez_card.*";
            "device.product.id" = "0x0cd3";
            "device.vendor.id" = "usb:054c";
          }
        ];
        actions.update-props = {
          "bluez5.auto-connect" = [ "a2dp_sink" ];
          "bluez5.a2dp.ldac.quality" = "hq";
          "device.profile" = "a2dp-sink";
        };
      }
    ];

    shells.zsh.enable = true;

    terminals = {
      alacritty.enable = true;
      foot.enable = true;
      wezterm.enable = true;
    };
  };
}
