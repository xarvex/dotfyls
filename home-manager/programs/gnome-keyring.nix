{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.gnome-keyring;
in
{
  options.dotfyls.programs.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable { dotfyls.persist.directories = [ ".local/share/keyrings" ]; };
}
