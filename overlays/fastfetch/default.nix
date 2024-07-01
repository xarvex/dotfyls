final: prev:

prev.fastfetch.overrideAttrs (o: {
  patches = (o.patches or [ ]) ++ [
    ./nixos_old_small.patch
    ./nixos_small.patch
  ];
})
