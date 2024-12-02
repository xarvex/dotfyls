{ config, lib, ... }:

let
  cfg' = config.dotfyls.security;
  cfg = cfg'.gnome-keyring;
  hmCfg = config.hm.dotfyls.security.gnome-keyring;
in
{
  options.dotfyls.security.gnome-keyring.enable = lib.mkEnableOption "GNOME Keyring" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;
  };
}
