{ ... }:

{
  dotfyls = {
    power.management = true;
    # Currently hardened kernel means suspending cuts power to laptop.
    security.harden.kernel.replace = false;
  };

  hardware.enableRedistributableFirmware = true;

  networking.hostId = "3540bf30";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
