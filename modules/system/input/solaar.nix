{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.input;
  cfg = cfg'.solaar;
  hmCfg = config.hm.dotfyls.input.solaar;
in
{
  options.dotfyls.input.solaar.enable = lib.mkEnableOption "Solaar" // {
    default = hmCfg.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
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
