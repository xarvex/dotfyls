{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.programs.discord;
in
{
  options.dotfyls.programs.discord = {
    enable = lib.mkEnableOption "Discord" // { default = false; };
    package = lib.mkPackageOption pkgs "Discord" { default = "discord"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];

    dotfyls.persist.cacheDirectories = [ ".config/discord" ];
  };
}
