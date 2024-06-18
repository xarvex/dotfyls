# DO NOT IMPORT
# THIS DOES NOT WORK AND IS HERE IF I EVER FIX IT
{ config, inputs, lib, ... }:

let
  cfg = config.custom.disk;
in
{
  options.custom.disk = {
    main = lib.mkOption {
      type = lib.types.str;
      description = "Main system disk device";
    };
    swapsize = lib.mkOption {
      type = lib.types.str;
      description = "Size of the swap";
    };
  };

  config.disko = {
    enableConfig = false;
    devices = {
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "defaults"
            "size=2G"
            "mode=755"
          ];
        };
      };

      disk.main = {
        type = "disk";
        device = cfg.main;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = cfg.swapsize;
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };

      zpool = {
        zroot = {
          type = "zpool";
          rootFsOptions = {
            canmount = "off";
            compression = "zstd";
          };
          datasets = {
            nix = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options.mountpoint = "legacy";
            };
            persist = {
              type = "zfs_fs";
              mountpoint = "/persist";
              options.mountpoint = "legacy";
            };
            cache = {
              type = "zfs_fs";
              mountpoint = "/persist/cache";
              options.mountpoint = "legacy";
            };
          };
        };
      };
    };
  };
}
