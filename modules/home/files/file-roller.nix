{ config, lib, ... }:

let
  cfg = config.dotfyls.files.file-roller;
in
{
  options.dotfyls.files.file-roller.enable = lib.mkEnableOption "File Roller";

  config = lib.mkIf cfg.enable {
  };
}
