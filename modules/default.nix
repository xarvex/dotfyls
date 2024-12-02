{
  nixosModules.files = import ./files.nix true;

  homeManagerModules.files = import ./files.nix false;
}
