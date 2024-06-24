# Configurations adapted from the NixOS hardened profile
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
{ ... }:

{
  imports = [
    ./harden
  ];
}
