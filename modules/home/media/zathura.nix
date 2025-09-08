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
    dotfyls.file.".local/share/zathura" = {
      mode = "0700";
      cache = true;
    };

    programs.zathura = {
      enable = true;

      options = {
        # girara
        guioptions = "shv";
        statusbar-h-padding = 0;
        statusbar-v-padding = 0;

        # zathura
        continuous-hist-save = true;
        database = "sqlite";
        recolor = true;
        selection-clipboard = "clipboard";
      };
      mappings = {
        p = "print";
        i = "recolor";
      };
    };
  };
}
