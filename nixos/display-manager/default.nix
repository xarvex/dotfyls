{ config, lib, ... }:

{
  imports = [
    ./sddm.nix
  ];

  options.dotfyls.displayManager = {
    enable = lib.mkEnableOption "display manager" // { default = config.dotfyls.desktops.enable; };
    provider = lib.mkOption {
      type = lib.types.enum [ "sddm" ];
      default = "sddm";
      example = "sddm";
      description = "Display manager to use.";
    };
  };
}
