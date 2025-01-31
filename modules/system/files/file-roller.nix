{ config, lib, ... }:

let
  cfg = config.dotfyls.files.file-roller;
  hmCfg = config.hm.dotfyls.files.file-roller;
in
{
  options.dotfyls.files.file-roller.enable = lib.mkEnableOption "File Roller" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable { programs.file-roller.enable = true; };
}
