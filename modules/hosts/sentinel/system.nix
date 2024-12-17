_:

{
  dotfyls = {
    boot.kernel.variant = "xanmod";

    graphics.provider = "nvidia";

    programs.openrgb = {
      sizes = ./openrgb/sizes.ors;
      bootProfile = ./openrgb/Overglow.orp;
    };

    security.harden.kernel.enable = false;
  };
}
