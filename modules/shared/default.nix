{ lib }:

let
  modules' = [
    "files"
    "nix"
  ];
  modules = lib.genAttrs modules' (module': import ./${module'}.nix);
in
{
  nixosModules = builtins.mapAttrs (_: module: module true) modules;

  homeManagerModules = builtins.mapAttrs (_: module: module false) modules;
}
