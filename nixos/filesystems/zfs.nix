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

          kernelPackages = lib.mkForce (
            assert lib.assertMsg (lib.versionOlder cfg.package.version "2.3")
              "ZFS 2.3 supports kernel 6.11 or greater";
            pkgs.linuxPackagesFor (
              pkgs.linux_xanmod_latest.override {
                argsOverride = rec {
                  version = "6.10.11";
                  modDirVersion = lib.versions.pad 3 "${version}-xanmod1";
                  src = pkgs.fetchFromGitHub {
                    owner = "xanmod";
                    repo = "linux";
                    rev = modDirVersion;
                    hash = "sha256-FDWFpiN0VvzdXcS3nZHm1HFgASazNX5+pL/8UJ3hkI8=";
                  };
                };
              }
            )
          );
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
