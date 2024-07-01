{ config, lib, pkgs, ... }:

{
  options.custom.programs.discord.enable = lib.mkEnableOption "Discord" // { default = true; };

  config = lib.mkIf config.custom.programs.discord.enable {
    home.packages = with pkgs; [ discord ];
  };
}
