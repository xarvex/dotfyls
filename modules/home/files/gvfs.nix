{ config, lib, ... }:

let
  cfg = config.dotfyls.files.gvfs;
in
{
  options.dotfyls.files.gvfs.enable = lib.mkEnableOption "GVfs";

  config = lib.mkIf cfg.enable {
    dotfyls.file.".local/share/gvfs-metadata" = {
      mode = "0700";
      persist = true;
    };
  };
}
