{ config, lib, ... }:

let
  cfg = config.dotfyls.files.gvfs;
  hmCfg = config.hm.dotfyls.files.gvfs;
in
{
  options.dotfyls.files.gvfs.enable = lib.mkEnableOption "GVfs" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable { services.gvfs.enable = true; };
}
