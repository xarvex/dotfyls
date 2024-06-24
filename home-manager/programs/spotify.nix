{ config, lib, pkgs, ... }:

{
  options.custom.programs.spotify.enable = lib.mkEnableOption "Enable Spotify (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.spotify.enable {
    home.packages = with pkgs; [ spotify ];
  };
}
