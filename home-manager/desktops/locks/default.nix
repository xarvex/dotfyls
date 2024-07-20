{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops.locks;
in
{
  imports = [
    ./hyprlock.nix
    ./swaylock.nix
  ];

  options.dotfyls.desktops.locks = {
    enable = lib.mkEnableOption "desktop locks" // { default = true; };
    command = pkgs.lib.dotfyls.mkCommandOption "lock"
      // lib.optionalAttrs cfg.enable {
      default = pkgs.lib.dotfyls.mkCommand (''
        case $XDG_CURRENT_DESKTOP in
      ''
      + (lib.concatStringsSep "\n" (
        let
          desktops = builtins.attrValues config.dotfyls.desktops.desktops;
          lockFor = desktop: cfg.locks.${desktop.lock.provider};
        in
        lib.map
          (desktop: ''
            ${desktop.sessionName})
              exec ${lib.getExe (lockFor desktop).command}
              ;;
          '')
          (builtins.filter (desktop: desktop.enable && desktop.lock.enable && (lockFor desktop).enable) desktops)
      ))
      + ''
        esac
      '');
    };
  };

  config.dotfyls.desktops.locks.locks.${config.dotfyls.desktops.desktops.${config.dotfyls.desktops.default}.lock.provider}.enable = lib.mkIf cfg.enable true;
}
