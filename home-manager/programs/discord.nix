{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.discord.enable = lib.mkEnableOption "Discord" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.discord.enable {
    home.packages = with pkgs; [ discord ];

    dotfyls.persist.cacheDirectories = [ ".config/discord" ];
  };
}
