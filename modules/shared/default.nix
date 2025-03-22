{ lib }:

let
  modules' = [
    "appearance_fonts"
    "file"
    "nix"
  ];
  modules = lib.genAttrs modules' (module': import ./${module'}.nix);
in
{
  nixosModules = builtins.mapAttrs (_: module: module true) modules;

  homeModules = builtins.mapAttrs (_: module: module false) modules;
}
