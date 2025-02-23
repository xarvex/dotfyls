{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.libreoffice;
in
{
  options.dotfyls.media.libreoffice.enable = lib.mkEnableOption "LibreOffice" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file.".config/libreoffice".cache = true;

      mime-apps = {
        office = {
          presentation = "impress.desktop";
          spreadsheet = "calc.desktop";
          word = "writer.desktop";
        };
        extraSchemes = {
          ms-access = "startcenter.desktop";
          ms-excel = "startcenter.desktop";
          ms-powerpoint = "startcenter.desktop";
          ms-visio = "startcenter.desktop";
          ms-word = "startcenter.desktop";
          "vnd.libreoffice.cmis" = "startcenter.desktop";
          "vnd.libreoffice.command" = "startcenter.desktop";
          "vnd.sun.star.webdav" = "startcenter.desktop";
          "vnd.sun.star.webdavs" = "startcenter.desktop";
        };
      };
    };

    home.packages = with pkgs; [
      (symlinkJoin {
        inherit (libreoffice) name meta;

        paths = [
          libreoffice
          hunspellDicts.en_US
          hunspellDicts.sv_SE

          corefonts
          vista-fonts
        ];
      })
    ];
  };
}
