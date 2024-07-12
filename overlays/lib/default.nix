final: prev:

(prev.lib or { }).extend (self: super: {
  dotfyls = {
    kernel = prev.callPackage ./kernel.nix { };
  };
})
