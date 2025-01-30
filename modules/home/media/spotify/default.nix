{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.spotify;
in
{
  options.dotfyls.media.spotify = {
    enable = lib.mkEnableOption "Spotify" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Spotify" { default = "spotify"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      file = {
        ".config/spotify".cache = true;
        ".cache/spotify".cache = true;
      };

      mime-apps.extraSchemes.spotify = "spotify.desktop";
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
