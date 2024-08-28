{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.xwaylandvideobridge;
in
{
  options.dotfyls.programs.xwaylandvideobridge = {
    enable = lib.mkEnableOption "XWayland Video Bridge" // { default = true; };
    package = lib.mkPackageOption pkgs "XWayland Video Bridge" { default = "xwaylandvideobridge"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
