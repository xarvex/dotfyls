{ config, lib, pkgs, ... }:

{
  options.custom.programs.xwaylandvideobridge.enable = lib.mkEnableOption "Enable XWayland Video Bridge (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.xwaylandvideobridge.enable {
    home.packages = with pkgs; [ xwaylandvideobridge ];
  };
}
