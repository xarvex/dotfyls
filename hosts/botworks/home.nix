{ inputs, pkgs, ... }: {

  dotfyls = {
    defaultTerminal = "kitty"; # WezTerm breaks on NVIDIA.
    terminals.fontSize = 20;

    desktops = {
      displays = [{
        name = "DP-2";
        width = 3840;
        height = 2160;
        refresh = 144;
      }];
    };
  };
}
