{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.wl-clipboard;
in
{
  options.dotfyls.programs.wl-clipboard = {
    enable = lib.mkEnableOption "wl-clipboard";
    package = lib.mkPackageOption pkgs "wl-clipboard" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
