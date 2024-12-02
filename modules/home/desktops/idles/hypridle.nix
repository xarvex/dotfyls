{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.desktops;
  cfg' = cfg''.idles;
  cfg = cfg'.idles.hypridle;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "desktops"
        "idles"
        "idles"
        "hypridle"
      ]
      [
        "services"
        "hypridle"
      ]
    )
  ];

  options.dotfyls.desktops.idles.idles.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    services.hypridle = {
      enable = true;

      settings =
        let
          # https://github.com/hyprwm/hypridle/issues/73
          # Yes, this is a hacky workaround, yes /tmp is not desirable.
          # I have been struggling with this for several days.
          afterSleepCommand = pkgs.dotfyls.mkCommandExe {
            runtimeInputs = with pkgs; [ coreutils ];
            text = "(sleep 15; rm /tmp/hypridle_lock) &";
          };
          beforeCommand =
            command:
            pkgs.dotfyls.mkCommandExe {
              runtimeInputs = with pkgs; [
                coreutils
                procps
              ];
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
              lCfg = cfg'.lock;
              lockSession = pkgs.dotfyls.mkCommandExe {
                runtimeInputs = with pkgs; [ systemd ];
                text = "exec loginctl lock-session";
              };
            in
            lib.mkIf lCfg.enable {
              general = {
                lock_cmd = lib.getExe lCfg.command;
                before_sleep_cmd = pkgs.dotfyls.mkCommandExe {
                  runtimeInputs = with pkgs; [ coreutils ];
                  text = "touch /tmp/hypridle_lock; exec ${lockSession}";
                };
              };

              listener = [
                {
                  inherit (lCfg) timeout;

                  on-timeout = beforeCommand lockSession;
                }
              ];
            }
          )

          (
            let
              dCfg = cfg'.displays;
            in
            lib.mkIf dCfg.enable {
              general.after_sleep_cmd = pkgs.dotfyls.mkCommandExe "${afterSleepCommand}; ${lib.getExe dCfg.onCommand}";

              listener = [
                {
                  inherit (dCfg) timeout;

                  on-timeout = beforeCommand dCfg.offCommand;
                  on-resume = lib.getExe dCfg.onCommand;
                }
              ];
            }
          )

          (
            let
              sCfg = cfg'.suspend;
            in
            lib.mkIf sCfg.enable {
              listener = [
                {
                  inherit (sCfg) timeout;

                  on-timeout = beforeCommand sCfg.command;
                }
              ];
            }
          )
        ];
    };
  };
}
