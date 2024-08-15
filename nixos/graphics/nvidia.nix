{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.graphics.graphics.nvidia;
in
{
  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

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

    nix.settings = {
      substituters = [ "https://cuda-maintainers.cachix.org" ];
      trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
    };
  };
}
