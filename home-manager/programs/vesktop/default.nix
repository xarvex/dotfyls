{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.programs.vesktop;
in
{
  options.dotfyls.programs.vesktop = {
    enable = lib.mkEnableOption "Vesktop" // { default = config.dotfyls.desktops.enable; };
    package = lib.mkPackageOption pkgs "Vesktop" { default = "vesktop"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];

    dotfyls.persist.cacheDirectories = [ ".config/vesktop/sessionData" ];
  };
}
