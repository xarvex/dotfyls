{ lib, pkgs, ... }:

{
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  systemd.user.services.spice-agent = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${lib.getExe' pkgs.spice-vdagent "spice-vdagent"} -x ";
    unitConfig = {
      ConditionVirtualization = "botworks-virtualized";
      Description = [ "Spice guest session agent" ];
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
  };

  /*
    custom.disk = {
    main = "/dev/vda";
    swapsize = "4G";
    };
  */

  networking.hostId = "3bb44cc9";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
