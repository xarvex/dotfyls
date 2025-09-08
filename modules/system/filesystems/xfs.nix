{ config, lib, ... }:

let
  cfg' = config.dotfyls.filesystems;
  cfg = cfg'.xfs;
in
{
  options.dotfyls.filesystems.xfs.enable = lib.mkEnableOption "XFS";

  config = lib.mkIf cfg.enable { boot.supportedFilesystems.xfs = true; };
}
