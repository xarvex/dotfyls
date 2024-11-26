{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.distrobox;
in
{
  options.dotfyls.programs.distrobox = {
    enable = lib.mkEnableOption "Distrobox";
    package = lib.mkPackageOption pkgs "Distrobox" { default = "distrobox"; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.programs.podman.enable = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile."distrobox/distrobox.conf".source = ./distrobox.conf;
  };
}
