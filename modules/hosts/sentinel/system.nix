_:

{
  dotfyls = {
    graphics.provider = "nvidia";

    kernels.variant = "xanmod";

    programs.openrgb = {
      sizes = ./openrgb/sizes.ors;
      bootProfile = ./openrgb/Overglow.orp;
    };

    security.harden.kernel.enable = false;
  };
}
