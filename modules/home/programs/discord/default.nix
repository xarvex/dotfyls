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
    dotfyls.file.".config/discord" = {
      mode = "0700";
      cache = true;
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
