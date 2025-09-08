{ config, lib, ... }:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.flatpak;
in
{
  options.dotfyls.containers.flatpak.enable = lib.mkEnableOption "Flatpak";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".var".cache = true;

      ".config/flatpak".cache = true;
      ".local/share/flatpak".cache = true;
      ".cache/flatpak".cache = true;
    };
  };
}
