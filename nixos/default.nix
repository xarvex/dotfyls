{ ... }:

{
  imports = [
    ./boot.nix
    ./configuration.nix
    ./desktop.nix
    ./harden.nix
    ./filesystem
    ./nix.nix
    ./persist.nix
    ./shells.nix
    ./users.nix
  ];
}
