{ config, lib, pkgs, ... }:

{
  options.custom.programs.xwaylandvideobridge.enable = lib.mkEnableOption "XWayland Video Bridge" // { default = true; };

  config = lib.mkIf config.custom.programs.xwaylandvideobridge.enable {
    home.packages = with pkgs; [ xwaylandvideobridge ];
  };
}
