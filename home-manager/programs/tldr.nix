{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.programs.tldr;
in
{
  options.dotfyls.programs.tldr = {
    enable = lib.mkEnableOption "tldr" // { default = true; };
    package = lib.mkPackageOption pkgs "tldr" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];
  };
}
