{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.ventoy;
in
{
  options.dotfyls.programs.ventoy = {
    enable = lib.mkEnableOption "Ventoy" // { default = config.dotfyls.desktops.enable; };
    package = lib.mkPackageOption pkgs "Ventoy" { default = "ventoy-full"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
