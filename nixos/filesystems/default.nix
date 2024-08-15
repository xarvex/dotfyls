{ lib, self, ... }:

{
  imports = [
    ./impermanence.nix
    ./zfs.nix

    (self.lib.mkSelectorModule [ "dotfyls" "filesystems" ]
      {
        name = "main";
        default = "zfs";
        description = "Main filesystem to use.";
      }
      {
        zfs = "ZFS";
      })
  ];

  options.dotfyls.filesystems.encryption = lib.mkEnableOption "filesystem encryption" // { default = true; };

  config = {
    boot.tmp.cleanOnBoot = true;

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

    };

    swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];
    zramSwap.enable = true;
  };
}
