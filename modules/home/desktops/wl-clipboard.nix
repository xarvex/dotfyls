{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.wl-clipboard;
in
{
  options.dotfyls.desktops.wl-clipboard.enable = lib.mkEnableOption "wl-clipboard";

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = with pkgs; [ wl-clipboard ]; };
}
