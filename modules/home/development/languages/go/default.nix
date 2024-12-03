{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.go;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".local/share/go/bin".persist = true;
      ".cache/go/build".cache = true;
      ".cache/go/mod".cache = true;
    };

    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
      GOCACHE = "${config.xdg.cacheHome}/go/build";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    };
  };
}
