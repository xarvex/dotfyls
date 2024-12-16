{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.graphics;
  cfg = cfg'.graphics.nvidia;
in
{
  options.dotfyls.graphics.graphics.nvidia.enable = lib.mkEnableOption "Nvidia graphics";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.graphics.extraPackages = with pkgs; [
      egl-wayland

      libglvnd
    ];

    boot.blacklistedKernelModules = [
      "amdgpu"
      "i915"
      "xe"
    ];

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";

      # https://discourse.nixos.org/t/drm-kernel-driver-nvidia-drm-in-use-nvk-requires-nouveau/42222/28
      # VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.${pkgs.stdenv.hostPlatform.linuxArch}.json";
      # https://discourse.nixos.org/t/vulkaninfo-failure/10143/2
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.${pkgs.stdenv.hostPlatform.linuxArch}.json";
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
