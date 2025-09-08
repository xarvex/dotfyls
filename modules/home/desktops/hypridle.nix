{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.hypridle;

  systemctl = config.systemd.user.systemctlPath;
  loginctl = "${dirOf systemctl}/loginctl";

  hyprctl = self.lib.getCfgExe' config.wayland.windowManager.hyprland "hyprctl";
in
{
  options.dotfyls.desktops.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.hypridle = {
      enable = true;

      # Use a lock to prevent system from immediately processing listeners
      # after waking from suspend. Yes, this is a hacky workaround.
      # Issue: https://github.com/hyprwm/hypridle/issues/73
      settings = {
        general = {
          before_sleep_cmd = ''${lib.getExe' pkgs.coreutils "touch"} "''${XDG_RUNTIME_DIR}/hypridle_lock"; ${loginctl} lock-session'';
          after_sleep_cmd = ''${lib.getExe pkgs.dash} -c 'sleep 15; rm "''${XDG_RUNTIME_DIR}/hypridle_lock"'; ${hyprctl} dispatch dpms on'';
        }
        // lib.optionalAttrs cfg'.hyprlock.enable {
          lock_cmd = "${lib.getExe' pkgs.procps "pidof"} -q hyprlock || ${self.lib.getCfgExe config.programs.hyprlock}";
          unlock_cmd = "${lib.getExe' pkgs.procps "pkill"} -USR1 hyprlock";
          inhibit_sleep = 3;
        };

        listener =
          let
            preTimeout = ''[ ! -f "''${XDG_RUNTIME_DIR}/hypridle_lock" ] && '';
          in
          (lib.optional (cfg'.lockTimeout != 0) {
            on-timeout = "${preTimeout}${loginctl} lock-session";
            timeout = cfg'.lockTimeout;
          })
          ++ (lib.optional (cfg'.displayTimeout != 0) {
            on-timeout = "${preTimeout}${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
            timeout = cfg'.displayTimeout;
          })
          ++ (lib.optional (cfg'.suspendTimeout != 0) {
            on-timeout = "${preTimeout}${systemctl} suspend";
            timeout = cfg'.suspendTimeout;
          });
      };
    };
  };
}
