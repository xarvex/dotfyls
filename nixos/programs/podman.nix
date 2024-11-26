{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.podman;
  hmCfg = config.hm.dotfyls.programs.podman;
in
{
  options.dotfyls.programs.podman.enable = lib.mkEnableOption "Podman" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;

      dockerCompat = true;
    };
  };
}
