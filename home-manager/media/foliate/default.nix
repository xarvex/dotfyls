{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.foliate;
in
{
  options.dotfyls.media.foliate = {
    enable = lib.mkEnableOption "Foliate" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Foliate" { default = "foliate"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.files.cacheDirectories = [
      ".local/share/com.github.johnfactotum.Foliate"
      ".cache/com.github.johnfactotum.Foliate"
    ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}