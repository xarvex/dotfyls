# All things security. Very much TODO.
# Configurations in harden are optional (though enabled by default).
# Configurations outside of that are required.
# What did you expect from a cybersecurity guy?
# 
# Resouces used:
#   https://nixos.wiki/wiki/Security
#   https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
#   https://madaidans-insecurities.github.io/guides/linux-hardening.html
#   https://github.com/a13xp0p0v/kernel-hardening-checker
#   https://dataswamp.org/~solene/2022-01-13-nixos-hardened.html
#   https://medium.com/@ganga.jaiswal/88bb7d77ba22
_:

{
  imports = [
    ./harden
    ./kernel.nix
  ];
}
