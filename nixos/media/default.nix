{ config, lib, ... }:

let
  hmCfg = config.hm.dotfyls.media;
in
{
  imports = [
    ./gvfs.nix
    ./pipewire.nix
  ];

  options.dotfyls.media.enable = lib.mkEnableOption "media" // {
    default = hmCfg.enable;
  };
}
