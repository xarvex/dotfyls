{ config, lib, ... }:

let
  cfg' = config.dotfyls.containers;
  cfg = cfg'.podman;
in
{
  options.dotfyls.containers.podman.enable = lib.mkEnableOption "Podman";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/containers" = {
      mode = "0700";
      cache = true;
    };
  };
}
