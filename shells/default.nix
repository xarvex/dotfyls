{ lib, pkgs }:

rec {
  default = dotfyls;

  dotfyls = import ./dotfyls.nix { inherit lib pkgs; };

  dotfyls-modules-home-editors-neovim = import ./dotfyls-modules-home-editors-neovim.nix {
    inherit dotfyls pkgs;
  };

  dotfyls-modules-home-terminals-wezterm = import ./dotfyls-modules-home-terminals-wezterm.nix {
    inherit dotfyls pkgs;
  };
}
