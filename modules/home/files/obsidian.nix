{
  config,
  lib,
  pkgs,
  self,
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
    dotfyls.file.".config/obsidian" = {
      mode = "0700";
      cache = true;
    };

    # TODO: Configure with home-manager.
    home.packages = with pkgs; [ obsidian ];

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, O, exec, ${self.lib.getCfgExe config.programs.obsidian}"
    ];
  };
}
