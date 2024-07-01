{ config, lib, pkgs, ... }:

{
  options.dotfyls.graphics.nvidia = {
    enable = lib.mkEnableOption "NVIDIA graphics";
    blacklistCompeting = lib.mkEnableOption "blacklisting competing graphics drivers" // { default = true; };
  };

  config = lib.mkIf config.dotfyls.graphics.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      # Use NVIDIA framebuffer.
      # See: https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers#Kernel_module_parameters
      kernelParams = [ "nvidia-drm.fbdev=1" ];
    } // lib.optionalAttrs config.dotfyls.graphics.nvidia.blacklistCompeting {
      blacklistedKernelModules = [ "amdgpu" "i915" ];
    };

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
