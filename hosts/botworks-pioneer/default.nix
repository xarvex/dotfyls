{ ... }:

{
  hardware.enableRedistributableFirmware = true;
  powerManagement.enable = true;

  networking.hostId = "3540bf30";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
