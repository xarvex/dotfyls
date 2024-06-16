{ inputs, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (_: prev: {
      fastfetch = prev.fastfetch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [
          ./fastfetch-nixos-old-small.patch
          ./fastfetch-nixos-small.patch
        ];
      });
    })
  ];
}
