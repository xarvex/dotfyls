{ ... }:

{
  dotfyls = {
    graphics.nvidia.enable = true;
    security.harden.kernel.enable = false;
    filesystems.zfs.unstable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "";

  hardware.enableRedistributableFirmware = true;
}
