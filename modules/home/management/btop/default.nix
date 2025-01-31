{ config, lib, ... }:

let
  cfg' = config.dotfyls.management;
  cfg = cfg'.btop;
in
{
  options.dotfyls.management.btop.enable = lib.mkEnableOption "Btop" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.btop = {
      enable = true;

      settings = {
        theme_background = false;
        vim_keys = true;
        update_ms = 1000;
      };
    };
  };
}
