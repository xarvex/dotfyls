{ config, lib, ... }:

{
  imports = [ ./fonts.nix ];

  options.dotfyls.appearance.enable = lib.mkEnableOption "appearance" // {
    default = config.dotfyls.desktops.enable;
  };
}
