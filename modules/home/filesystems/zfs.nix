{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.filesystems.zfs;
  osCfg = if osConfig == null then null else osConfig.dotfyls.filesystems.zfs;
in
{
  options.dotfyls.filesystems.zfs.enable = lib.mkEnableOption "ZFS" // {
    default = osCfg != null && osCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      zfs-compress = "zfs list -o name,used,compressratio,lused,avail";
      zfs-crypt = "zfs list -o name,encryptionroot,encryption";
      zfs-snaps = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";
    };
  };
}
