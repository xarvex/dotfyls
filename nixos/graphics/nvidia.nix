{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.graphics.nvidia;
in
{
  options.dotfyls.graphics.nvidia = {
    enable = lib.mkEnableOption "NVIDIA graphics";
    blacklistCompeting = lib.mkEnableOption "blacklisting competing graphics drivers" // { default = true; };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      # See: https://wiki.gentoo.org/wiki/NVIDIA/nvidia-drivers#Kernel_module_parameters
      kernelParams = [
        # Use NVIDIA framebuffer.
        "nvidia-drm.fbdev=1"

        # https://wiki.hyprland.org/Nvidia/#suspendwakeup-issues
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ];
    } // lib.optionalAttrs config.dotfyls.graphics.nvidia.blacklistCompeting {
      blacklistedKernelModules = [ "amdgpu" "i915" ];
    };

    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
      graphics.extraPackages = with pkgs; [
        egl-wayland

        mesa
        libglvnd
        nvidia-vaapi-driver
        vaapiVdpau

        vulkan-extension-layer
        vulkan-loader
        vulkan-validation-layers
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";

      # https://discourse.nixos.org/t/drm-kernel-driver-nvidia-drm-in-use-nvk-requires-nouveau/42222/28
      # VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.${pkgs.stdenv.hostPlatform.linuxArch}.json";
      # https://discourse.nixos.org/t/vulkaninfo-failure/10143/2
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.${pkgs.stdenv.hostPlatform.linuxArch}.json";
    };

    nix.settings = {
      substituters = [ "https://cuda-maintainers.cachix.org" ];
      trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
    };
  };
}
