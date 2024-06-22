{ config, lib, pkgs, ... }:

{
  options.custom.program.spotify.enable = lib.mkEnableOption "Spotify" // { default = true; };

  config = lib.mkIf config.custom.program.spotify.enable {
    home.packages = with pkgs; [ spotify ];
  };
}
