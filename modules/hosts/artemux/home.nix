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

    shells.zsh.enable = true;

    terminals = {
      alacritty.enable = true;
      foot.enable = true;
      wezterm.enable = true;
    };
  };
}
