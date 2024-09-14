{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.go;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.cacheDirectories = [
      ".local/share/go"
      ".cache/go/build"
      ".cache/go/mod"
    ];

    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
      GOCACHE = "${config.xdg.cacheHome}/go/build";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    };
  };
}
