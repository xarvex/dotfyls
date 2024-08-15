final: prev:

# Build failure due to missing spirv-tools.
# See: https://github.com/NixOS/nixpkgs/issues/334822
prev.vulkan-validation-layers.overrideAttrs (o: {
  buildInputs = o.buildInputs ++ [ prev.spirv-tools ];
})
