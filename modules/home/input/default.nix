{ config, lib, ... }:

{
  imports = [
    ./kanata
    ./solaar

    ./uinput.nix
  ];

  options.dotfyls.input.enable = lib.mkEnableOption "input" // {
    default = config.dotfyls.desktops.enable;
  };
}
