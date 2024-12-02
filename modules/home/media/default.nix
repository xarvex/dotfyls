{ config, lib, ... }:

{
  imports = [
    ./foliate
    ./libreoffice
    ./mpv
    ./nemo
    ./nomacs
    ./steam
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
