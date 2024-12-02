{ config, lib, ... }:

let
  cfg = config.dotfyls.security.gnome-keyring;
in
{
  options.dotfyls.security.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.files.".local/share/keyrings" = {
      mode = "0700";
      persist = true;
    };
  };
}
