{
  config,
  lib,
  self,
  ...
}:

{
  imports = [
    ./zfs

    ./impermanence.nix

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "files"
        "systems"
      ]
      {
        name = "main";
        default = "zfs";
        description = "Main filesystem to use.";
      }
      { zfs = "ZFS"; }
    )
  ];

  options.dotfyls.files.systems.encryption = lib.mkEnableOption "filesystem encryption" // {
    default = !(builtins.elem "virtio_pci" config.boot.initrd.availableKernelModules);
  };

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

    swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];
    zramSwap.enable = true;
  };
}