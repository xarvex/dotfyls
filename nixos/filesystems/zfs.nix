{ config, lib, pkgs, ... }:

{
  options.dotfyls.filesystems.zfs = {
    enable = lib.mkEnableOption "ZFS filesystem";
    unstable = lib.mkEnableOption "unstable ZFS filesystem";
  };

  config =
    let
      cfg = config.dotfyls.filesystems.zfs;
    in
    lib.mkIf cfg.enable {
      boot = {
        supportedFilesystems.zfs = true;
        zfs = {
          devNodes = lib.mkDefault "/dev/disk/by-id";
          package = lib.mkIf cfg.unstable pkgs.zfs_unstable;
        };
      };

      services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };

      # https://github.com/openzfs/zfs/issues/10891
      systemd.services.systemd-udev-settle.enable = false;

      dotfyls.kernels.version = if cfg.unstable then "6.9.9" else config.boot.zfs.package.latestCompatibleLinuxPackages.kernel.version;
    };
}
