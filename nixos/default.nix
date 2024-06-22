{ ... }:

{
  imports = [
    ./configuration.nix
    ./harden.nix
    ./filesystem
    ./nix.nix
    ./persist.nix
    ./programs.nix
    ./users.nix
    ./window-managers.nix
  ];
}
