{
  inputs,
  lib,
  self,
}:

let
  overlays' = [
    ./bat-extras
    ./evil-winrm
    ./vesktop

    ./nix-index-unwrapped.nix
  ];
  overlays = builtins.listToAttrs (
    map (
      overlay:
      lib.nameValuePair (self.lib.moduleNameOf overlay) (
        final: prev: {
          ${self.lib.moduleNameOf overlay} = import overlay { inherit inputs; } final prev;
        }
      )
    ) overlays'
  );
in
overlays
// {
  default =
    # WARNING: Later elements replace duplicates, however will not occur thanks to above's unique keys.
    final: prev: lib.mergeAttrsList (map (overlay: overlay final prev) (builtins.attrValues overlays));
}
