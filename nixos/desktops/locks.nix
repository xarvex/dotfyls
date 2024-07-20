{ config, lib, pkgs, ... }:

{
  options.dotfyls.desktops.locks = {
    hyprlock.enable = lib.mkEnableOption "hyprlock" // { default = config.hm.dotfyls.desktops.locks.locks.hyprlock.enable; };
    swaylock.enable = lib.mkEnableOption "swaylock" // { default = config.hm.dotfyls.desktops.locks.locks.swaylock.enable; };
  };

  config = let cfg = config.dotfyls.desktops.locks; in lib.mkIf config.dotfyls.desktops.enable (lib.mkMerge [
    (lib.mkIf cfg.hyprlock.enable {
      security.pam.services.hyprlock = { };
    })

    (lib.mkIf cfg.swaylock.enable {
      security.pam.services.swaylock = { };
    })
  ]);
}
