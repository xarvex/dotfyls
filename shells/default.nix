{ pkgs, self }:

rec {
  default = dotfyls;

  dotfyls = import ./dotfyls.nix { inherit pkgs self; };

  dotfyls-modules-home-files-neovim-nvim = import ./dotfyls-modules-home-files-neovim-nvim.nix {
    inherit dotfyls pkgs;
  };

  dotfyls-modules-home-terminals-terminals-wezterm-wezterm =
    import ./dotfyls-modules-home-terminals-terminals-wezterm-wezterm.nix
      { inherit dotfyls pkgs; };
}
