{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.desktops.idles.idles.hypridle;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "desktops" "idles" "idles" "hypridle" "package" ]
      [ "services" "hypridle" "package" ])
  ];

  options.dotfyls.desktops.idles.idles.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings =
        let
          # https://github.com/hyprwm/hypridle/issues/73
          # Yes, this is a hacky workaround, yes /tmp is not desirable.
          # I have been struggling with this for several days.
          afterSleepCommand = pkgs.lib.dotfyls.mkCommandExe {
            runtimeInputs = with pkgs; [ coreutils ];
            text = "(sleep 15; rm /tmp/hypridle_lock) &";
          };
          beforeCommand = command: pkgs.lib.dotfyls.mkCommandExe {
            runtimeInputs = with pkgs; [ coreutils procps ];
            text = ''
              [ -f /tmp/hypridle_lock ] || exec ${if lib.isString command then command else lib.getExe command}
            '';
          };
        in
        lib.mkMerge [
          {
            general = {
              ignore_dbus_inhibit = false;
              after_sleep_cmd = lib.mkDefault afterSleepCommand;
            };
          }

          (
            let
              cfg = config.dotfyls.desktops.idles.lock;
              lockSession = pkgs.lib.dotfyls.mkCommandExe {
                runtimeInputs = with pkgs; [ systemd ];
                text = "exec loginctl lock-session";
              };
            in
            lib.mkIf cfg.enable {
              general = {
                lock_cmd = lib.getExe cfg.command;
                before_sleep_cmd = pkgs.lib.dotfyls.mkCommandExe {
                  runtimeInputs = with pkgs; [ coreutils ];
                  text = "touch /tmp/hypridle_lock; exec ${lockSession}";
                };
              };

              listener = [{
                timeout = cfg.timeout;
                on-timeout = beforeCommand lockSession;
              }];
            }
          )

          (
            let cfg = config.dotfyls.desktops.idles.displays; in lib.mkIf cfg.enable {
              general.after_sleep_cmd = pkgs.lib.dotfyls.mkCommandExe "${afterSleepCommand}; ${lib.getExe cfg.onCommand}";

              listener = [{
                timeout = cfg.timeout;
                on-timeout = beforeCommand cfg.offCommand;
                on-resume = lib.getExe cfg.onCommand;
              }];
            }
          )

          (
            let cfg = config.dotfyls.desktops.idles.suspend;
            in lib.mkIf cfg.enable {
              listener = [{
                timeout = cfg.timeout;
                on-timeout = beforeCommand cfg.command;
              }];
            }
          )
        ];
    };
  };
}
