{ config, lib, pkgs, ... }:

{
  options.custom.programs.spotify.enable = lib.mkEnableOption "Spotify" // { default = true; };

  config = lib.mkIf config.custom.programs.spotify.enable {
    home.packages = with pkgs; [ spotify ];
  };
}
