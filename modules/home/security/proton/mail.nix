{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.security.proton;
  cfg = cfg'.mail;
in
{
  options.dotfyls.security.proton.mail.enable = lib.mkEnableOption "Proton Mail" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/Proton Mail" = {
      mode = "0700";
      cache = true;
    };

    home.packages = [ (lib.hiPrio pkgs.protonmail-desktop) ];

    xdg.mimeApps.defaultApplications."x-scheme-handler/mailto" = "proton-mail.desktop";
  };
}
