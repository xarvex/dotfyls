{ self, ... }:

{
  imports = [
    self.nixosModules.file

    ./file-roller.nix
    ./gvfs.nix
    ./localsend.nix
  ];
}
