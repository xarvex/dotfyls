{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.podman;
in
{
  options.dotfyls.programs.podman.enable = lib.mkEnableOption "Podman";

  config = lib.mkIf cfg.enable {
    dotfyls.files.".local/share/containers" = {
      mode = "0700";
      cache = true;
    };
  };
}
