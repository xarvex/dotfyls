{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops;
in
{
  imports = [
    ./hyprland.nix
    ./locks.nix
  ];

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // { default = config.hm.dotfyls.desktops.enable; };
    default = lib.mkOption {
      type = lib.types.enum [ "hyprland" ];
      default = config.hm.dotfyls.desktops.default;
      example = "hyprland";
      description = "Default desktop to use.";
    };
    launchCommand = pkgs.lib.dotfyls.mkCommandOption "launch default desktop"
      // { default = cfg.desktops.${cfg.default}.command; };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.desktops.desktops.${cfg.default}.enable = true;

    services.xserver = {
      updateDbusEnvironment = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = with pkgs; [ xterm ];
    };

    security.polkit.enable = true;
  };
}
