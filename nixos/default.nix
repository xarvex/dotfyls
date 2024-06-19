{ ... }:

{
  imports = [
    ./configuration.nix
    ./filesystem
    ./nix.nix
    ./persist.nix
    ./program.nix
    ./user.nix
    ./window-manager.nix
  ];
}
