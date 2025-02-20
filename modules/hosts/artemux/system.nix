_:

{
  dotfyls = {
    boot = {
      kernel.variant = "xanmod";
      console = {
        efi = {
          width = 1920;
          height = 1080;
        };
        displays = rec {
          eDP-1 = {
            width = 1920;
            height = 1200;
            refresh = 60;
          };
          HDMI-A-1 = {
            width = 1920;
            height = 1080;
            refresh = 75;
          };
          DP-3 = HDMI-A-1;
        };
      };
    };

    graphics = {
      provider = "intel";
      graphics.intel.forceFullRGB = [
        322
        356
      ];
    };

    management.power.battery = true;

    security.harden.kernel.packages = false;
  };
}
