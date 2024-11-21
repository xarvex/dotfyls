{ config, lib, ... }:

{
  imports = [
    ./mime-apps.nix
    ./mpris.nix
    ./nomacs
    ./pipewire.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = config.dotfyls.desktops.enable;
  };
}
