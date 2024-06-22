{ ... }:

{
  nixpkgs.overlays = [
    (_: prev: {
      fastfetch = prev.fastfetch.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [
          ./fastfetch-nixos-old-small.patch
          ./fastfetch-nixos-small.patch
        ];
      });

      # until release made and available
      wezterm = prev.wezterm.overrideAttrs (o: {
        # https://github.com/wez/wezterm/pull/5264
        patches = (o.patches or [ ]) ++ [ ./wezterm-5264.patch ];
      });
    })
  ];
}
