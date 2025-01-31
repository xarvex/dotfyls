{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.programs.solaar;
  hmCfg = config.hm.dotfyls.programs.solaar;
in
{
  options.dotfyls.programs.solaar.enable = lib.mkEnableOption "Solaar" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ solaar ];

    hardware.logitech.wireless.enable = true;

    systemd.user.services.solaar = {
      description = "Solaar, the open source driver for Logitech devices";
      wantedBy = [ "graphical-session.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' pkgs.solaar "solaar"} --window hide";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}
