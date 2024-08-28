{ ... }:

{
  dotfyls = {
    filesystems = {
      encryption = false;
      filesystems.zfs.unstable = true;
    };

    security.harden.kernel.enable = false;

    graphics.provider = "nvidia";

    programs.openrgb = {
      sizes = ./openrgb/sizes.ors;
      bootProfile = ./openrgb/Overglow.orp;
    };
  };
}
