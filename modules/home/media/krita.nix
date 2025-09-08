{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.krita;
in
{
  options.dotfyls.media.krita.enable = lib.mkEnableOption "Krita" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/krita".cache = true;

    home.packages = with pkgs; [ krita ];

    xdg.mimeApps.associations.removed = {
      "application/pdf" = "krita_pdf.desktop";
      "text/csv" = "krita_csv.desktop";
    };
  };
}
