{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.flatpak;
in
{
  options.dotfyls.programs.flatpak.enable = lib.mkEnableOption "Flatpak";

  config = lib.mkIf cfg.enable {
    dotfyls.files.cacheDirectories = [
      ".var"

      ".config/flatpak"
      ".local/share/flatpak"
      ".cache/flatpak"
    ];
  };
}
