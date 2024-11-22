{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.gvfs;
in
{
  options.dotfyls.media.gvfs.enable = lib.mkEnableOption "GVfs";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.directories = [ ".local/share/gvfs-metadata" ];
  };
}
