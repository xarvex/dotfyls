{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.discord;
in
{
  options.dotfyls.programs.discord = {
    enable = lib.mkEnableOption "Discord";
    package = lib.mkPackageOption pkgs "Discord" { default = "discord"; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ ".config/discord" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
