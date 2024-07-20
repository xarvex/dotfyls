{ config, lib, ... }:

{
  imports = [
    ./sddm.nix
    ./greetd.nix
  ];

  options.dotfyls.displayManager = {
    enable = lib.mkEnableOption "display manager" // { default = config.dotfyls.desktops.enable; };
    provider = lib.mkOption {
      type = lib.types.enum [ "greetd" "sddm" ];
      default = "greetd";
      example = "sddm";
      description = "Display manager to use.";
    };
  };

  config = let cfg = config.dotfyls.displayManager; in lib.mkIf cfg.enable {
    dotfyls.displayManager.displayManager.${cfg.provider}.enable = true;
  };
}
