{ config, lib, pkgs, ... }:

{
  options.custom.graphics.nvidia.enable = lib.mkEnableOption "Enable NVIDIA graphics";

  config = lib.mkIf config.custom.graphics.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    # Use NVIDIA framebuffer
    # See: https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers#Kernel_module_parameters
    boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
      graphics.extraPackages = with pkgs; [ vaapiVdpau ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    nix.settings = {
      substituters = [ "https://cuda-maintainers.cachix.org" ];
      trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
    };
  };
}
