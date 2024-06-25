{ config, lib, ... }:

{
  options.custom.programs.waybar.enable = lib.mkEnableOption "Enable Waybar (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      # TODO: theme
    };
  };
}
