{ ... }:

{
  imports = [
    ./boot.nix
    ./configuration.nix
    ./desktop.nix
    ./filesystem
    ./nix.nix
    ./persist.nix
    ./security
    ./shells.nix
    ./users.nix
  ];
}
