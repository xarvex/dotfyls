final: prev:

(prev.lib or { }).extend (self: super: {
  # WARNING: later elements replace duplicates
  dotfyls = super.mergeAttrsList [
    (prev.callPackage ./commands.nix { })
    (prev.callPackage ./desktops.nix { })
  ];
})
