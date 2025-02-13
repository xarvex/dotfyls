{
  inputs,
  lib,
  self,
}:

let
  overlays = [
    "bat-extras"
    "colloid-icon-theme"
    "evil-winrm"
    "llvmPackages_14"
    "nix-index-unwrapped"
    "vesktop"
  ];
in
lib.genAttrs overlays (
  overlay: final: prev: { ${overlay} = import ./${overlay} { inherit inputs; } final prev; }
)
// {
  default =
    # WARNING: Later elements replace duplicates, however will not occur thanks to above's unique keys.
    final: prev: lib.mergeAttrsList (lib.map (overlay: self.overlays.${overlay} final prev) overlays);
}
