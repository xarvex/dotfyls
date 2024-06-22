{ config, lib, ... }:

{
  boot = {
    supportedFilesystems.zfs = true;
    zfs.devNodes = lib.mkDefault "/dev/disk/by-id";
    kernelPackages = lib.mkDefault config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  # https://github.com/openzfs/zfs/issues/10891
  systemd.services.systemd-udev-settle.enable = false;
}
