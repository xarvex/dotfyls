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
    ./zathura

    ./mpris.nix
    ./pipewire.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = config.dotfyls.desktops.enable;
  };
}
