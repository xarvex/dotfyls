{ ... }:

{
  dotfyls = {
    kernels.variant = "zen";
    graphics.provider = "intel";

    power.management = true;
    security.harden.kernel.packages = false;
    filesystems.filesystems.zfs.unstable = true;
  };
}
