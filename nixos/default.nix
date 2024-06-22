{ ... }:

{
  imports = [
    ./configuration.nix
    ./harden.nix
    ./filesystem
    ./nix.nix
    ./persist.nix
    ./program.nix
    ./user.nix
    ./window-manager.nix
  ];
}
