{ config, lib, ... }:

let
  cfg = config.dotfyls.security.clamav;
in
{
  options.dotfyls.security.clamav.enable = lib.mkEnableOption "ClamAV" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file."/var/lib/clamav" = {
      user = config.services.clamav.daemon.settings.User;
      cache = true;
    };

    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
      fangfrisch = {
        enable = true;

        # False positive flags for package libraries.
        settings.sanesecurity.enabled = "no";
      };
      scanner.enable = true;
    };
  };
}
