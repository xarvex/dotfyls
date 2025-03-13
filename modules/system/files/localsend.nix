{ config, lib, ... }:

let
  cfg = config.dotfyls.files.localsend;
  hmCfg = config.hm.dotfyls.files.localsend;
in
{
  options.dotfyls.files.localsend.enable = lib.mkEnableOption "LocalSend" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };
}
