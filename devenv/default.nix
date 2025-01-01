{
  inputs,
  lib,
  pkgs,
}:

rec {
  default = dotfyls;

  dotfyls = import ./dotfyls.nix { inherit inputs lib pkgs; };

  dotfyls-neovim = import ./dotfyls-neovim.nix { inherit dotfyls lib pkgs; };

  dotfyls-wezterm = import ./dotfyls-wezterm.nix { inherit dotfyls lib pkgs; };
}
