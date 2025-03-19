{ config, lib, ... }:

{
  imports = [
    ./foliate
    ./inkscape
    ./libreoffice
    ./mpv
    ./nomacs
    ./plattenalbum
    ./spotify
    ./tagstudio
    ./zathura

    ./mpris.nix
    ./pipewire.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = config.dotfyls.desktops.enable;
  };
}
