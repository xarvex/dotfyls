{ ... }:

{
  dotfyls = {
    power.management = true;
    # Causes suspending to suddenly cut power.
    security.harden.kernel = {
      packages = false;
      poison = false;
    };
  };

  hardware.enableRedistributableFirmware = true;

  networking.hostId = "3540bf30";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
