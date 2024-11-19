{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.spotify;
in
{
  options.dotfyls.programs.spotify = {
    enable = lib.mkEnableOption "Spotify" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Spotify" { default = "spotify"; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ ".cache/spotify" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
