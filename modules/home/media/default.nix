{ config, lib, ... }:

{
  imports = [
    ./mpv
    ./nomacs

    ./control.nix
    ./foliate.nix
    ./inkscape.nix
    ./krita.nix
    ./libreoffice.nix
    ./mpris.nix
    ./obs.nix
    ./pipewire.nix
    ./plattenalbum.nix
    ./spotify.nix
    ./tagstudio.nix
    ./yt-dlp.nix
    ./zathura.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = config.dotfyls.desktops.enable;
  };
}
