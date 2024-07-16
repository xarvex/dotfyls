final: prev:

(prev.lib or { }).extend (self: super: {
  dotfyls = {
    workspaces = prev.callPackage ./workspaces.nix { };
  };
})
