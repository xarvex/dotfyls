{
  nixosModules.files = import ./shared/files.nix true;

  homeManagerModules.files = import ./shared/files.nix false;
}
