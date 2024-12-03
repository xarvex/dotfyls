{ self, ... }:

{
  imports = [
    self.homeManagerModules.file

    ./nemo

    ./gvfs.nix
  ];
}
