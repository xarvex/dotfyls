{ lib, self }:

let
  modules' = [
    ./appearance_fonts.nix
    ./file.nix
    ./filesystems_drives.nix
    ./meta.nix
    ./nix.nix
  ];
  modules = builtins.listToAttrs (
    map (module: lib.nameValuePair (self.lib.moduleNameOf module) (import module)) modules'
  );
in
{
  nixosModules = builtins.mapAttrs (_: module: module true) modules;

  homeModules = builtins.mapAttrs (_: module: module false) modules;
}
