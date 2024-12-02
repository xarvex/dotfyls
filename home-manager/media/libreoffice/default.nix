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
    dotfyls.files.".config/libreoffice".cache = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
