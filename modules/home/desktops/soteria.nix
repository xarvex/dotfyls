{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.desktops;
  cfg = cfg'.soteria;
in
{
  options.dotfyls.desktops.soteria.enable = lib.mkEnableOption "Soteria";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    systemd.user.services.polkit-soteria = {
      Unit = {
        Description = "Soteria, Polkit authentication agent for any desktop environment";
        After = [ "graphical-session-pre.target" ];
        Wants = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = lib.getExe pkgs.soteria;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    wayland.windowManager.hyprland.settings.windowrule = [
      "tag +important-prompt, class:(?:${lib.escapeRegex "gay.vaskel."})?soteria"

      "noscreenshare, class:(?:${lib.escapeRegex "gay.vaskel."})?soteria"
      "dimaround, class:(?:${lib.escapeRegex "gay.vaskel."})?soteria, floating:1"
    ];
  };
}
