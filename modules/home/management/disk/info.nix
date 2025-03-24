{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.management.disk;
  cfg = cfg'.info;

  iniFormat = pkgs.formats.ini { };
in
{
  options.dotfyls.management.disk.info.enable = lib.mkEnableOption "QDiskInfo" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = with pkgs; [ qdiskinfo ];

    xdg.configFile."qdiskinfo/qdiskinfo.conf".source = iniFormat.generate "qdiskinfo-conf" {
      General = {
        HEX = false;
        IgnoreC4 = true;
      };
    };
  };
}
