{ ... }:

{
  imports = [
    ./configuration.nix
    ./harden.nix
    ./filesystem
    ./nix.nix
    ./persist.nix
    ./shells.nix
    ./users.nix
    ./window-managers.nix
  ];
}
