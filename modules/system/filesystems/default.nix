{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.filesystems;
in
{
  imports = [
    ./zfs

    ./drives.nix
    ./impermanence.nix
    ./swap.nix
    ./xfs.nix
  ];

  options.dotfyls.filesystems = {
    main = lib.mkOption {
      type = lib.types.enum [ "zfs" ];
      default = "zfs";
      description = "Main filesystem to use.";
    };
    encrypt = lib.mkEnableOption "filesystem encryption" // {
      default = !config.dotfyls.meta.machine.isVirtual;
      defaultText = lib.literalExpression "!config.dotfyls.meta.machine.isVirtual";
    };
    bootLabel = lib.mkOption {
      type = lib.types.str;
      default = "NIXBOOT";
      example = "boot";
      description = "Label of the boot partition.";
    };
  };

  config = {
    dotfyls.filesystems = lib.mkMerge [
      (self.lib.enableSelected cfg.main [ "zfs" ])
      (self.lib.enableSelected' "enableMain" cfg.main [ "zfs" ])
    ];

    environment = {
      systemPackages = [ self.packages.${pkgs.system}.dotfyls-install ];
      sessionVariables.DOTFYLS_FLAKE = lib.mkIf (
        config.dotfyls.meta.location != null
      ) config.dotfyls.meta.location;
    };

    fileSystems."/boot" = {
      label = cfg.bootLabel;
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
