{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.openrgb;
in
{
  options.dotfyls.programs.openrgb.enable = lib.mkEnableOption "OpenRGB";

  config = lib.mkIf cfg.enable { dotfyls.files.persistDirectories = [ ".config/OpenRGB" ]; };
}
