{ self, ... }:

{
  imports = [
    self.nixosModules.file

    ./systems

    ./file-roller.nix
    ./gvfs.nix
    ./localsend.nix
  ];
}
