{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.libreoffice;
in
{
  options.dotfyls.media.libreoffice = {
    enable = lib.mkEnableOption "LibreOffice" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "LibreOffice" { default = "libreoffice"; };
    finalPackage = self.lib.mkFinalPackageOption "LibreOffice" // {
      default = pkgs.symlinkJoin {
        inherit (cfg.package) name meta;

        paths =
          [ cfg.package ]
          ++ (with pkgs.hunspellDicts; [
            en_US
            sv_SE
          ]);
      };
    };
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

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
