{ config, lib, ... }:

{
  imports = [
    ./impermanence.nix
    ./zfs.nix
  ];

  options.dotfyls.mainFilesystem = lib.mkOption {
    type = lib.types.enum [ "zfs" ];
    default = "zfs";
    example = "zfs";
    description = "Main filesystem to use.";
  };

  config = {
    dotfyls.filesystems.${config.dotfyls.mainFilesystem}.enable = true;

    fileSystems = {
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=1G"
          "mode=755"
        ];
        neededForBoot = true;
      };

      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

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
        neededForBoot = true;
      };
      "/persist/cache" = {
        device = "zroot/cache";
        fsType = "zfs";
        neededForBoot = true;
      };
    };

    # Clear, as /tmp is a ZFS dataset.
    boot.tmp.cleanOnBoot = true;

    swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];
    zramSwap.enable = true;

    # sudo cannot store that it has been ran.
    security.sudo.extraConfig = "Defaults lecture=never";
  };
}
