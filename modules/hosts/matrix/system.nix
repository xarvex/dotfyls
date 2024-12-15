{ lib, pkgs, ... }:

{
  dotfyls.displayManager = {
    enable = true;
    provider = "cage";
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  systemd.user.services.spice-agent = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${lib.getExe' pkgs.spice-vdagent "spice-vdagent"} -x";
    unitConfig = {
      ConditionVirtualization = "vm";
      Description = [ "Spice guest session agent" ];
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
  };
}
