{ config, lib, ... }:

let
  cfg' = config.dotfyls.networking;
  cfg = cfg'.manager;
in
{
  options.dotfyls.networking.manager.enable = lib.mkEnableOption "NetworkManager" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      "/etc/NetworkManager".persist = true;
      "/var/lib/NetworkManager" = {
        mode = "0700";
        cache = true;
      };
    };

    networking.networkmanager.enable = true;
  };
}
