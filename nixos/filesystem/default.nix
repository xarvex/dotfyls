{ ... }:

{
  imports = [
    # ./disko.nix # DO NOT IMPORT
    ./impermanence.nix
    ./zfs.nix
  ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=10G"
        "mode=755"
      ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

    "/nix" = {
      device = "zroot/nix";
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

  swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];
  zramSwap.enable = true;

  # sudo cannot store that it has been ran
  security.sudo.extraConfig = "Defaults lecture=never";
}
