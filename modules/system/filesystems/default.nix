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
    efiLabel = lib.mkOption {
      type = lib.types.str;
      default = "efi";
      example = "efi";
      description = "Label of the EFI partition.";
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

    boot.loader.efi.efiSysMountPoint = "/efi";

    fileSystems."/efi" = {
      label = cfg.efiLabel;
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
