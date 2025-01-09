{
  inputs,
  lib,
  pkgs,
}:

rec {
  default = dotfyls;

  dotfyls = import ./dotfyls.nix { inherit inputs lib pkgs; };

  dotfyls-modules-home-files-neovim-nvim = import ./dotfyls-modules-home-files-neovim-nvim.nix {
    inherit dotfyls lib pkgs;
  };

  dotfyls-modules-home-terminals-terminals-wezterm-wezterm =
    import ./dotfyls-modules-home-terminals-terminals-wezterm-wezterm.nix
      { inherit dotfyls lib pkgs; };
}
