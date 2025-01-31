{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.files.obsidian;
in
{
  options.dotfyls.files.obsidian.enable = lib.mkEnableOption "Obsidian" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      file.".config/obsidian" = {
        mode = "0700";
        cache = true;
      };

      mime-apps.extraSchemes.obsidian = "obsidian.desktop";
    };

    home.packages = with pkgs; [ obsidian ];
  };
}
