{ config, lib, ... }:

let
  cfg = config.dotfyls.management.solaar;
  hmCfg = config.hm.dotfyls.management.solaar;
in
{
  options.dotfyls.management.solaar.enable = lib.mkEnableOption "Solaar" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable { hardware.logitech.wireless.enable = true; };
}
