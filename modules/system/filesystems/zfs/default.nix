{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.filesystems;
  cfg = cfg'.zfs;
in
{
  imports = [ ./autosnap.nix ];

  options.dotfyls.filesystems.zfs = {
    enable = lib.mkEnableOption "ZFS";
    enableMain = lib.mkEnableOption "ZFS as main filesystem";

    unstable = lib.mkEnableOption "unstable ZFS" // {
      default = true;
    };
    nodes = lib.mkOption {
      type = lib.types.enum [
        "by-id"
        "by-partuuid"
      ];
      default =
        if !config.dotfyls.meta.machine.isVirtual && config.hardware.cpu.intel.updateMicrocode then
          "by-id"
        else
          "by-partuuid";
      defaultText = lib.literalExpression ''
        if !config.dotfyls.meta.machine.isVirtual && config.hardware.cpu.intel.updateMicrocode then
          "by-id"
        else
          "by-partuuid"
      '';
      example = "by-partuuid";
      description = "Device node path to use for `config.boot.zfs.devNodes`.";
    };
    pool = lib.mkOption {
      type = lib.types.str;
      default = "zroot";
      example = "zroot";
      description = "Name of the main ZFS pool, if there is one.";
    };
  };

  config = lib.mkMerge [
    { boot.supportedFilesystems.zfs = cfg.enable; }

    (lib.mkIf cfg.enable {
      dotfyls.boot.kernel.filterBroken = [ config.boot.zfs.package.kernelModuleAttribute ];

      services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };

      boot.zfs = {
        package = lib.mkIf cfg.unstable pkgs.zfs_unstable;

        devNodes = "/dev/disk/${cfg.nodes}";
        requestEncryptionCredentials = cfg'.encrypt;
      };

      # https://github.com/openzfs/zfs/issues/10891
      systemd.services.systemd-udev-settle.enable = false;

      fileSystems = lib.mkIf cfg.enableMain (
        let
          mkPoolFS = mountpoint: {
            device = "${cfg.pool}/${mountpoint}";
            fsType = "zfs";
          };
        in
        if cfg'.impermanence.enable then
          builtins.listToAttrs (
            map (mountpoint: lib.nameValuePair "/${mountpoint}" (mkPoolFS mountpoint)) [
              "nix"
              "persist"
              "cache"
            ]
          )
        else
          { "/" = mkPoolFS "root"; }
      );
    })
  ];
}
