{ config, lib, ... }:

{
  options.dotfyls.programs.waybar.enable = lib.mkEnableOption "Waybar" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      # TODO: theme
    };
  };
}
