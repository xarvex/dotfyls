{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.files.systems;
  cfg = cfg'.systems.zfs;
in
{
  imports = [ ./autosnap.nix ];

  options.dotfyls.files.systems.systems.zfs = {
    enable = lib.mkEnableOption "ZFS filesystem";
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
      defaultText = lib.literalExpression ''
        if (
            config.hardware.cpu.intel.updateMicrocode
            && !(builtins.elem "virtio_pci" config.boot.initrd.availableKernelModules)
          )
        then
          "by-id"
        else
          "by-partuuid"
      '';
      example = "by-partuuid";
      description = "Device node path to use for devNodes.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.boot.kernel.filterBroken = [ config.boot.zfs.package.kernelModuleAttribute ];

        boot = {
          supportedFilesystems.zfs = true;

          zfs = {
            package = lib.mkIf cfg.unstable pkgs.zfs_unstable;

            devNodes = "/dev/disk/${cfg.nodes}";
            requestEncryptionCredentials = cfg'.encrypt;
          };
        };

        services.zfs = {
          autoScrub.enable = true;
          trim.enable = true;
        };

        # https://github.com/openzfs/zfs/issues/10891
        systemd.services.systemd-udev-settle.enable = false;

        fileSystems =
          if cfg'.impermanence.enable then
            {
              "/nix" = {
                device = "zroot/nix";
                fsType = "zfs";
              };
              "/tmp" = {
                device = "zroot/tmp";
                fsType = "zfs";
              };
              "/persist" = {
                device = "zroot/persist";
                fsType = "zfs";
              };
              "/cache" = {
                device = "zroot/cache";
                fsType = "zfs";
              };
            }
          else
            {
              "/" = {
                device = "zroot/root";
                fsType = "zfs";
              };
            };
      }
    ]
  );
}
