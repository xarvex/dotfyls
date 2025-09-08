{ config, lib, ... }:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.podman;
  hmCfg = config.hm.dotfyls.containers.podman;
in
{
  options.dotfyls.containers.podman.enable = lib.mkEnableOption "Podman" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    virtualisation.podman = {
      enable = true;

      dockerCompat = true;
    };
  };
}
