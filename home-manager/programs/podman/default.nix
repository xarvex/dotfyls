{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.podman;
in
{
  options.dotfyls.programs.podman.enable = lib.mkEnableOption "Podman";

  config = lib.mkIf cfg.enable { dotfyls.persist.cacheDirectories = [ ".local/share/containers" ]; };
}