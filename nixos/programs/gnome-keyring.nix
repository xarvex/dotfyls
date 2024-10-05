{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.gnome-keyring;
  hmCfg = config.hm.dotfyls.programs.gnome-keyring;
in
{
  options.dotfyls.programs.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;
  };
}
