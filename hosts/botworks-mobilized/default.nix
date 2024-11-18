{ lib, pkgs, ... }:

{
  dotfyls = {
    filesystems.filesystems.zfs.unstable = true;

    security.harden.kernel.packages = false;

    kernels.variant = "xanmod";

    graphics.provider = "intel";

    power.management = true;
  };

  services.udev.extraRules = ''
    ACTION=="add", \
      SUBSYSTEM=="module", \
      KERNEL=="i915", \
      RUN+="${lib.getExe' pkgs.libdrm "proptest"} -M i915 -D /dev/dri/card1 322 connector 317 1"

    ACTION=="add", \
      SUBSYSTEM=="usb", \
      DRIVERS=="usb", \
      ATTRS{idVendor}=="046d", \
      ATTRS{idProduct}=="c548", \
      ATTR{power/wakeup}="disabled"
  '';
}
