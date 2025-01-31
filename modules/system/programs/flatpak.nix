{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.flatpak;
  hmCfg = config.hm.dotfyls.programs.flatpak;
in
{
  options.dotfyls.programs.flatpak.enable = lib.mkEnableOption "Flatpak" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file."/var/lib/flatpak".persist = true;

    services.flatpak.enable = true;
  };
}
