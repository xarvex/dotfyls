{ ... }:

{
  dotfyls = {
    power.management = true;
    # Causes suspending to suddenly cut power.
    security.harden.kernel = {
      packages = false;
      poison = false;
    };
    filesystems.zfs.nodes = "by-partuuid";
  };

  # Intel Bay Trail CPU bug.
  # See: https://medium.com/@dibyadas/b20281e4b2e2
  boot.kernelParams = [ "intel_idle.max_cstate=1" ];

  hardware.enableRedistributableFirmware = true;
}
