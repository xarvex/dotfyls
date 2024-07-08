{ ... }:

{
  dotfyls = {
    power.management = true;
    # Currently hardened kernel packages means suspending cuts power to laptop.
    security.harden.kernel.packages = false;
  };

  hardware.enableRedistributableFirmware = true;

  networking.hostId = "3540bf30";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
