{ ... }:

{
  dotfyls = {
    desktops = {
      displays = [{
        name = "DP-2";
        width = 3840;
        height = 2160;
        refresh = 144;
      }];
    };

    terminals = {
      default = "kitty"; # WezTerm breaks on NVIDIA.
      fontSize = 20;

      terminals = {
        alacritty.enable = true;
        wezterm.enable = true;
      };
    };
  };
}
