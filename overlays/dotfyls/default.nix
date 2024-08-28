final: prev:

(prev.dotfyls or { })
  # WARNING: later elements replace duplicates
  // (prev.lib.mergeAttrsList [
  (prev.callPackage ./commands.nix { })
])
