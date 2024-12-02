{
  nixosModules = {
    files = import ./shared/files.nix true;
    nix = import ./shared/nix.nix true;
  };

  homeManagerModules = {
    files = import ./shared/files.nix false;
    nix = import ./shared/nix.nix false;
  };
}
