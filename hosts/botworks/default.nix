{ ... }:

{
  dotfyls = {
    graphics.nvidia.enable = true;
    security.harden.kernel.enable = false;
    filesystems.zfs.unstable = true;
  };

  hardware.enableRedistributableFirmware = true;

  networking.hostId = "ef01cd45";
}
