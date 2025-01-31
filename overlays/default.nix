{ lib, self }:

let
  overlays = [
    "bat-extras"
    "evil-winrm"
    "fastfetch"
    "nix-index-unwrapped"
    "vesktop"
  ];
in
lib.genAttrs overlays (overlay: final: prev: { ${overlay} = import ./${overlay} final prev; })
// {
  default =
    # WARNING: later elements replace duplicates, however will not occur thanks to above's unique keys
    final: prev: lib.mergeAttrsList (lib.map (overlay: self.overlays.${overlay} final prev) overlays);
}
