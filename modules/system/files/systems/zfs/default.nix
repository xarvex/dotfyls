{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.files.systems;
  cfg = cfg'.systems.zfs;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "files"
        "systems"
        "systems"
        "zfs"
      ]
      [
        "boot"
        "zfs"
      ]
    )
  ];

  options.dotfyls.files.systems.systems.zfs = {
    enable = lib.mkEnableOption "ZFS";
    unstable = lib.mkEnableOption "unstable ZFS filesystem" // {
      default = true;
    };
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
          files.systems.systems.zfs.package = lib.mkIf cfg.unstable (lib.mkDefault pkgs.zfs_unstable);
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
