{ config, lib, pkgs, ... }:

{
  options.dotfyls.filesystems.zfs = {
    enable = lib.mkEnableOption "ZFS filesystem";
    unstable = lib.mkEnableOption "unstable ZFS filesystem";
    nodes = lib.mkOption {
      type = lib.types.enum [ "by-id" "by-partuuid" ];
      default = "by-id";
      example = "by-partuuid";
      description = "Device node path to use for devNodes.";
    };
  };

  config = let cfg = config.dotfyls.filesystems.zfs; in lib.mkIf cfg.enable {
    dotfyls.kernels.version = if cfg.unstable then "6.9.10" else config.boot.zfs.package.latestCompatibleLinuxPackages.kernel.version;

    boot = {
      supportedFilesystems.zfs = true;

      zfs = {
        devNodes = "/dev/disk/${cfg.nodes}";
        package = lib.mkIf cfg.unstable pkgs.zfs_unstable;
      };
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    # https://github.com/openzfs/zfs/issues/10891
    systemd.services.systemd-udev-settle.enable = false;
  };
}
