{ self, ... }:

{
  imports = [
    self.nixosModules.file

    ./systems

    ./gvfs.nix
  ];
}
