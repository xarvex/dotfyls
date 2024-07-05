{ ... }:

{
  hardware.enableRedistributableFirmware = true;

  networking.hostId = "3540bf30";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
