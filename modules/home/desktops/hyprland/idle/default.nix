{
  config,
  lib,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.desktops.hyprland;
  cfg = cfg'.idle;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "desktops"
        "desktops"
        "hyprland"
        "idle"
      ]
      [
        "services"
        "hypridle"
      ]
    )
  ];

  options.dotfyls.desktops.desktops.hyprland.idle.enable = lib.mkEnableOption "hypridle" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    services.hypridle = {
      enable = true;

      # Use a lock to prevent system from immediately processing listeners
      # after waking from suspend. Yes, this is a hacky workaround.
      # Issue: https://github.com/hyprwm/hypridle/issues/73
      settings = {
        general =
          {
            before_sleep_cmd = ''touch "''${XDG_RUNTIME_DIR}/hypridle_lock"; loginctl lock-session'';
            after_sleep_cmd = ''sh -c 'sleep 15; rm "''${XDG_RUNTIME_DIR}/hypridle_lock"'; hyprctl dispatch dpms on'';
          }
          // lib.optionalAttrs cfg'.lock.enable {
            lock_cmd = "pidof hyprlock || hyprlock";
            unlock_cmd = "pkill -USR1 hyprlock";
          };

        listener =
          (lib.optional (cfg''.lockTimeout != 0) {
            on-timeout = ''[ ! -f "''${XDG_RUNTIME_DIR}/hypridle_lock" ] && loginctl lock-session'';
            timeout = cfg''.lockTimeout;
          })
          ++ (lib.optional (cfg''.displayTimeout != 0) {
            on-timeout = ''[ ! -f "''${XDG_RUNTIME_DIR}/hypridle_lock" ] && hyprctl dispatch dpms off'';
            on-resume = "hyprctl dispatch dpms on";
            timeout = cfg''.displayTimeout;
          })
          ++ (lib.optional (cfg''.suspendTimeout != 0) {
            on-timeout = ''[ ! -f "''${XDG_RUNTIME_DIR}/hypridle_lock" ] && systemctl suspend'';
            timeout = cfg''.suspendTimeout;
          });
      };
    };
  };
}
