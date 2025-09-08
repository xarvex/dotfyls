{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.management.solaar;
in
{
  options.dotfyls.management.solaar = {
    enable = lib.mkEnableOption "Solaar";

    deviceConfig = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Solaar device config, note that this may need to be refreshed periodically.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ solaar ];

    xdg.configFile = {
      "solaar/config.yaml" = lib.mkIf (cfg.deviceConfig != null) {
        source = cfg.deviceConfig;
      };
      "solaar/rules.yaml".source = ./rules.yaml;
    };

    systemd.user.services.solaar = {
      Unit = {
        Description = "Solaar, the open source driver for Logitech devices";
        After = [ "dbus.service" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe' pkgs.solaar "solaar"} --window hide";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
