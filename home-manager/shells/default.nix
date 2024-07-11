{ ... }:

{
  imports = [
    ./zsh.nix
  ];

  programs.nix-index.enable = true;

  dotfyls.persist.cacheDirectories = [ ".cache/nix-index" ];
}
