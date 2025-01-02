{ lib }:

# WARNING: later elements replace duplicates
lib.mergeAttrsList [
  (import ./desktops.nix { inherit lib; })
  (import ./modules.nix { inherit lib; })
  (import ./options.nix { inherit lib; })
]
