{ config, lib, ... }:

let
  cfg = config.dotfyls.programs.openrgb;
in
{
  options.dotfyls.programs.openrgb.enable = lib.mkEnableOption "OpenRGB";

  # TODO: Confirm permissions.
  config = lib.mkIf cfg.enable { dotfyls.files.".config/OpenRGB".persist = true; };
}
