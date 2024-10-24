{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.filesystems;
  cfg = cfg'.filesystems.zfs;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "filesystems"
        "filesystems"
        "zfs"
      ]
      [
        "boot"
        "zfs"
      ]
    )
  ];

  options.dotfyls.filesystems.filesystems.zfs = {
    unstable = lib.mkEnableOption "unstable ZFS filesystem";
    nodes = lib.mkOption {
      type = lib.types.enum [
        "by-id"
        "by-partuuid"
      ];
      default =
        if
          (
            config.hardware.cpu.intel.updateMicrocode
            && !(builtins.elem "virtio_pci" config.boot.initrd.availableKernelModules)
          )
        then
          "by-id"
        else
          "by-partuuid";
      example = "by-partuuid";
      description = "Device node path to use for devNodes.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls = {
          filesystems.filesystems.zfs.package = lib.mkIf cfg.unstable (lib.mkDefault pkgs.zfs_unstable);
          kernels.version = lib.mkIf (!cfg.unstable) (
            lib.mkDefault cfg.package.latestCompatibleLinuxPackages.kernel.version
          );
        };

        boot = {
          supportedFilesystems.zfs = true;

          zfs = {
            devNodes = "/dev/disk/${cfg.nodes}";
            requestEncryptionCredentials = cfg'.encryption;
          };
        };

        services.zfs = {
          autoScrub.enable = true;
          trim.enable = true;
        };

        # https://github.com/openzfs/zfs/issues/10891
        systemd.services.systemd-udev-settle.enable = false;

        fileSystems =
          {
            "/nix" = {
              device = "zroot/nix";
              fsType = "zfs";
            };
            "/tmp" = {
              device = "zroot/tmp";
              fsType = "zfs";
            };
          }
          // lib.optionalAttrs cfg'.impermanence.enable {
            "/persist" = {
              device = "zroot/persist";
              fsType = "zfs";
            };
            "/cache" = {
              device = "zroot/cache";
              fsType = "zfs";
            };
          };
      }
    ]
  );
}
