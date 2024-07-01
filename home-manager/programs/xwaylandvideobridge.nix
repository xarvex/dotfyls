{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.xwaylandvideobridge.enable = lib.mkEnableOption "XWayland Video Bridge" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.xwaylandvideobridge.enable {
    home.packages = with pkgs; [ xwaylandvideobridge ];
  };
}
