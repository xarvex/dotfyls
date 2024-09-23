{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.locks;
in
{
  imports = [
    ./hyprlock.nix
    ./swaylock.nix
  ];

  options.dotfyls.desktops.locks = {
    enable = lib.mkEnableOption "desktop locks" // {
      default = true;
    };
    command =
      self.lib.mkCommandOption "lock"
      // lib.optionalAttrs cfg.enable {
        default = pkgs.dotfyls.mkCommand (
          ''
            case $XDG_CURRENT_DESKTOP in
          ''
          + (lib.concatStringsSep "\n" (
            let
              desktops = builtins.attrValues cfg'.desktops;
            in
            lib.map
              (desktop: ''
                ${desktop.sessionName})
                  exec ${lib.getExe desktop.lock.selected.command}
                  ;;
              '')
              (
                builtins.filter (
                  desktop: desktop.enable && desktop.lock.enable && desktop.lock.selected.enable
                ) desktops
              )
          ))
          + ''
            esac
          ''
        );
      };
  };
}
