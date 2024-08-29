{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.solaar;
  hmCfg = config.hm.dotfyls.programs.solaar;
in
{
  options.dotfyls.programs.solaar = {
    enable = lib.mkEnableOption "Solaar" // { default = hmCfg.enable; };
    package = lib.mkPackageOption pkgs "Solaar" { default = "solaar"; };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ (self.lib.getCfgPkg cfg) ];

    hardware.logitech.wireless.enable = true;

    systemd.user.services.solaar = {
      description = "Linux device manager for Logitech devices";
      wantedBy = [ "graphical-session.target" ];
      after = [ "dbus.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${self.lib.getCfgExe' cfg "solaar"} --window hide";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}
