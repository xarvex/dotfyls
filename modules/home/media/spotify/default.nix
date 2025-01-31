{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.spotify;
in
{
  options.dotfyls.media.spotify.enable = lib.mkEnableOption "Spotify" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file = {
        ".config/spotify".cache = true;
        ".cache/spotify".cache = true;
      };

      mime-apps.extraSchemes.spotify = "spotify.desktop";
    };

    home.packages = with pkgs; [ spotify ];
  };
}
