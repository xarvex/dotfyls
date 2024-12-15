_:

{
  dotfyls = {
    desktops.displays = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1200;
        refresh = 60;
        scale = 1.3333;
      }
      {
        name = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refresh = 75;
        position = "-1920x0";
      }
    ];

    programs.solaar = {
      enable = true;
      deviceConfig = ./solaar/config.yaml;
    };

    shells.shells.zsh.enable = true;

    terminals.terminals = {
      alacritty.enable = true;
      wezterm.enable = true;
    };
  };
}
