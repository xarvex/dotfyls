{ lib }:

let
  libs = [
    ./desktops.nix
    ./options.nix
    ./paths.nix
  ];
in
# WARNING: Later elements replace duplicates.
lib.mergeAttrsList (map (lib': import lib' { inherit lib; }) libs)
