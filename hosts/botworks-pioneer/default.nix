{ ... }:

{
  dotfyls = {
    power.management = true;
    # Causes suspending to suddenly cut power.
    security.harden.kernel = {
      packages = false;
      poison = false;
    };
  };

  hardware.enableRedistributableFirmware = true;

  # Intel Bay Trail CPU bug.
  # See: https://medium.com/@dibyadas/b20281e4b2e2
  boot.kernelParams = [ "intel_idle.max_cstate=1" ];

  networking.hostId = "3540bf30";
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
}
