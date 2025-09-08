{ config, lib, ... }:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.flatpak;
  hmCfg = config.hm.dotfyls.containers.flatpak;
in
{
  options.dotfyls.containers.flatpak.enable = lib.mkEnableOption "Flatpak" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file."/var/lib/flatpak".persist = true;

    services.flatpak.enable = true;
  };
}
