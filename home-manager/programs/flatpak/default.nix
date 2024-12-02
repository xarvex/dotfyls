{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.flatpak;
in
{
  options.dotfyls.programs.flatpak.enable = lib.mkEnableOption "Flatpak";

  config = lib.mkIf cfg.enable {
    dotfyls.files = {
      ".var".cache = true;

      ".config/flatpak".cache = true;
      ".local/share/flatpak".cache = true;
      ".cache/flatpak".cache = true;
    };
  };
}
