{ config, lib, pkgs, ... }:

{
  options.dotfyls.programs.spotify.enable = lib.mkEnableOption "Spotify" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.spotify.enable {
    home.packages = with pkgs; [ spotify ];
  };
}
