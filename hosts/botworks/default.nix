{ ... }:

{
  dotfyls = {
    graphics.provider = "nvidia";

    security.harden.kernel.enable = false;
    filesystems = {
      encryption = false;
      filesystems.zfs.unstable = true;
    };

    programs.openrgb = {
      sizes = ./openrgb/sizes.ors;
      bootProfile = ./openrgb/Overglow.orp;
    };
  };
}
