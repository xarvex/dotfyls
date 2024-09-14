{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.desktops.idles;
in
{
  imports = [
    ./hypridle.nix
    ./swayidle.nix
  ];

  options.dotfyls.desktops.idles =
    let
      mkTimeoutOption =
        action: default:
        lib.mkOption {
          inherit default;

          type = lib.types.int;
          description = "Timeout in seconds before ${action}.";
        };
    in
    {
      enable = lib.mkEnableOption "desktop idles" // {
        default = true;
      };
      lock = {
        enable = lib.mkEnableOption "lock idles" // {
          default = config.dotfyls.desktops.locks.enable;
        };
        timeout = mkTimeoutOption "lock" (5 * 60);
        command =
          self.lib.mkCommandOption "lock idle"
          // lib.optionalAttrs (cfg.enable && cfg.displays.enable) {
            default = config.dotfyls.desktops.locks.command;
          };
      };
      displays =
        let
          mkCommandOption =
            state:
            self.lib.mkCommandOption "idle displays ${state}"
            // lib.optionalAttrs (cfg.enable && cfg.displays.enable) {
              default = pkgs.dotfyls.mkCommand (
                ''
                  case $XDG_CURRENT_DESKTOP in
                ''
                + (lib.concatStringsSep "\n" (
                  let
                    desktops = builtins.attrValues config.dotfyls.desktops.desktops;
                  in
                  lib.map
                    (desktop: ''
                      ${desktop.sessionName})
                          exec ${lib.getExe desktop.idle.displays."${state}Command"}
                          ;;
                    '')
                    (
                      builtins.filter (
                        desktop: desktop.enable && desktop.idle.enable && desktop.idle.selected.enable
                      ) desktops
                    )
                ))
                + ''
                  esac
                ''
              );
            };
        in
        {
          enable = lib.mkEnableOption "display idles" // {
            default = true;
          };
          timeout = mkTimeoutOption "display idle" (cfg.lock.timeout + 30);
          onCommand = mkCommandOption "on";
          offCommand = mkCommandOption "off";
        };
      suspend = {
        enable = lib.mkEnableOption "suspend idles" // {
          default = true;
        };
        timeout = mkTimeoutOption "suspend" (cfg.lock.timeout + (10 * 60));
        command =
          self.lib.mkCommandOption "idle suspend"
          // lib.optionalAttrs (cfg.enable && cfg.suspend.enable) {
            default = pkgs.dotfyls.mkCommand {
              runtimeInputs = with pkgs; [ systemd ];
              text = "exec systemctl suspend";
            };
          };
      };
    };
}
