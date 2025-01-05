{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.files.systems.systems.zfs;
in
{
  options.dotfyls.files.systems.systems.zfs.enable =
    lib.mkEnableOption "ZFS filesystem"
    // lib.optionalAttrs (osConfig != null) {
      default = osConfig.dotfyls.files.systems.systems.zfs.enable;
    };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      zfs-compress = "zfs list -o name,used,compressratio,lused,avail";
      zfs-snaps = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";
    };
  };
}
