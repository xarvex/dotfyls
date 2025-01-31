{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.foliate;
in
{
  options.dotfyls.media.foliate.enable = lib.mkEnableOption "Foliate" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file = {
        ".local/share/com.github.johnfactotum.Foliate".cache = true;
        ".cache/com.github.johnfactotum.Foliate".cache = true;
      };

      mime-apps.media = {
        ebook = "com.github.johnfactotum.Foliate.desktop";
        pdf = lib.mkAfter "com.github.johnfactotum.Foliate.desktop";
      };
    };

    home.packages = with pkgs; [ foliate ];
  };
}
