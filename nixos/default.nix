{ config, lib, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./nix.nix
    ./program.nix
    ./user.nix
    ./window-manager.nix
  ];
}
