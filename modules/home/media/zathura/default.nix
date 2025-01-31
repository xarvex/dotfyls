{ config, lib, ... }:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.zathura;
in
{
  options.dotfyls.media.zathura.enable = lib.mkEnableOption "zathura" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file.".local/share/zathura" = {
        mode = "0700";
        cache = true;
      };

      mime-apps.media = {
        ebook = lib.mkAfter "org.pwmt.zathura.desktop";
        pdf = "org.pwmt.zathura.desktop";
      };
    };

    programs.zathura.enable = true;
  };
}
