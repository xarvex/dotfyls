{ config, lib, ... }:

{
  imports = [
    ./libreoffice
    ./mpv
    ./nemo
    ./nomacs
    ./spotify
    ./zathura

    ./gvfs.nix
    ./mime-apps.nix
    ./mpris.nix
    ./pipewire.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = config.dotfyls.desktops.enable;
  };
}
