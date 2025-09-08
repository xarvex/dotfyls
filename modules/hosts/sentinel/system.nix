{
  dotfyls = {
    meta = {
      machine.type = "desktop";
      hardware.threads = 20;
    };

    boot.kernel = {
      variant = "xanmod";
      harden.enable = false;
    };

    graphics.provider = "nvidia";

    management.rgb = {
      enable = true;
      sizes = ./openrgb/sizes.ors;
      bootProfile = ./openrgb/Overglow.orp;
    };
  };

  time.timeZone = "America/Chicago";
}
