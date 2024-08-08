{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.programs.cliphist;
in
{
  options.dotfyls.programs.cliphist = {
    enable = lib.mkEnableOption "cliphist";
    package = lib.mkPackageOption pkgs "cliphist" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];
  };
}
