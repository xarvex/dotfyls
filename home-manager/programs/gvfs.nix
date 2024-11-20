{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.gvfs;
in
{
  options.dotfyls.programs.gvfs.enable = lib.mkEnableOption "GVfs";

  config = lib.mkIf cfg.enable { dotfyls.persist.directories = [ ".local/share/gvfs-metadata" ]; };
}
