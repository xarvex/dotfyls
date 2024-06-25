{ config, lib, pkgs, ... }:

{
  options.custom.programs.discord.enable = lib.mkEnableOption "Enable Discord (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.discord.enable {
    home.packages = with pkgs; [ discord ];
  };
}
