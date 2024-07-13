{ ... }:

{
  dotfyls = {
    graphics.nvidia.enable = true;
    security.harden.kernel.enable = false;
  };

  hardware.enableRedistributableFirmware = true;

  networking.hostId = "ef01cd45";
}
