# TODO: make own version
{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.programs.cbonsai;
in
{
  options.dotfyls.programs.cbonsai = {
    enable = lib.mkEnableOption "cbonsai" // { default = true; };
    package = lib.mkPackageOption pkgs "cbonsai" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];
  };
}

