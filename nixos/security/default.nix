# All things security.
# Configurations in harden are optional (though enabled by default).
# Configurations outside of that are required.
# What did you expect from a cybersecurity guy?
# 
# Resouces used:
#   https://nixos.wiki/wiki/Security
#   https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
#   https://dataswamp.org/~solene/2022-01-13-nixos-hardened.html
{ ... }:

{
  imports = [
    ./harden
    ./kernel.nix
  ];
}
