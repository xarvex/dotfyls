{ ... }:

{
  dotfyls = {
    graphics.provider = "intel";

    power.management = true;
    # Causes suspending to suddenly cut power.
    security.harden.kernel = {
      packages = false;
      poison = false;
    };
  };

  # Intel Bay Trail CPU bug.
  # See: https://medium.com/@dibyadas/b20281e4b2e2
  boot.kernelParams = [ "intel_idle.max_cstate=1" ];
}
