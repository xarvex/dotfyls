{
  dotfyls = {
    meta.machine.type = "laptop";

    # Causes suspending to suddenly cut power.
    boot.kernel.harden.poison = false;

    graphics.provider = "intel";
  };

  # Intel Bay Trail CPU bug.
  # See: https://medium.com/@dibyadas/b20281e4b2e2
  boot.kernelParams = [ "intel_idle.max_cstate=1" ];
}
