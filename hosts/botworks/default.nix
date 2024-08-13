{ ... }:

{
  dotfyls = {
    graphics.provider = "nvidia";

    security.harden.kernel.enable = false;
    filesystems.zfs.unstable = true;

    programs.openrgb.bootProfile = ./openrgb/Overglow.orp;
  };

  hardware.enableRedistributableFirmware = true;
}
