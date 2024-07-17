{ config, lib, pkgs, ... }:

{
  imports = [
    ./hyprland.nix
  ];

  options.dotfyls.desktops = {
    enable = lib.mkEnableOption "desktops" // { default = config.hm.dotfyls.desktops.enable; };
    main = lib.mkOption
      {
        type = lib.types.enum [ "hyprland" ];
        default = "hyprland";
        example = "hyprland";
        description = "Main desktop to use.";
      } // { default = config.hm.dotfyls.desktops.main; };
  };

  config = let cfg = config.dotfyls.desktops; in lib.mkIf cfg.enable {
    dotfyls.desktops.desktops.${cfg.main}.enable = true;

    services.xserver = {
      updateDbusEnvironment = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = [ pkgs.xterm ];
    };

    security.polkit.enable = true;

    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "dotfyls-desktop";
        text = cfg.desktops.${cfg.main}.command;
      })
    ];
  };
}
