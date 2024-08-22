final: prev:

prev.fastfetch.overrideAttrs (o: {
  patches = (o.patches or [ ]) ++ [ ./nixos_small.patch ];
})
