{ lib, pkgs, ... }:

{
  dotfyls = {
    kernels.variant = "zen";
    graphics.provider = "intel";

    power.management = true;
    security.harden.kernel.packages = false;
    filesystems.filesystems.zfs.unstable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="module", KERNEL=="i915", RUN+="${lib.getExe' pkgs.libdrm "proptest"} -M i915 -D /dev/dri/card1 322 connector 317 1"
  '';
}
