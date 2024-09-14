{
  inputs,
  lib,
  self,
}:

# WARNING: later elements replace duplicates
lib.mergeAttrsList [
  (import ./configurations.nix { inherit inputs self; })
  (import ./desktops.nix { inherit lib; })
  (import ./modules.nix { inherit lib; })
  (import ./options.nix { inherit lib; })
]
