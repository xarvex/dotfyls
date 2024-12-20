{ lib, ... }:

{
  imports = [
    ./bash
    ./fish
    ./zsh
  ];

  dotfyls.shells.shells.bash.enable = lib.mkDefault true;
}
