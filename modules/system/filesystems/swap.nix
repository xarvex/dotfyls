{ config, lib, ... }:

let
  cfg' = config.dotfyls.filesystems;
  cfg = cfg'.swap;
in
{
  options.dotfyls.filesystems.swap = {
    enable = lib.mkEnableOption "swap" // {
      default = true;
    };

    label = lib.mkOption {
      type = lib.types.str;
      default = "swap";
      example = "swap";
      description = "Label of the swap partition.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.luks.devices.swap = lib.mkIf cfg'.encrypt {
      allowDiscards = true;
      bypassWorkqueues = true;
    };

    swapDevices = [
      (
        {
          label = lib.mkIf (!cfg'.encrypt) cfg.label;
          discardPolicy = "both";
        }
        // lib.optionalAttrs cfg'.encrypt {
          device = "/dev/mapper/${cfg.label}";
          encrypted = {
            enable = true;

            blkDev = "/dev/disk/by-label/${cfg.label}";
            inherit (cfg) label;
            keyFile = "/${
              if config.boot.initrd.systemd.enable then "sysroot" else "mnt-root"
            }${lib.optionalString cfg'.impermanence.enable "/persist"}/etc/cryptsetup-keys.d/${cfg.label}.key";
          };
        }
      )
    ];

    zramSwap.enable = true;
  };
}
