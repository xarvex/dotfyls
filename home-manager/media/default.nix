{ config, lib, ... }:

{
  imports = [
    ./mpris.nix
    ./pipewire.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = config.dotfyls.desktops.enable;
  };
}
