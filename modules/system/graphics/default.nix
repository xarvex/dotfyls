{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.graphics;
in
{
  imports = [
    ./intel.nix
    ./nvidia.nix

    (self.lib.mkSelectorModule [ "dotfyls" "graphics" ] {
      name = "provider";
      default = "intel"; # TODO: Remove default.
      example = "intel";
      description = "Graphics provider to use.";
    })
  ];

  options.dotfyls.graphics = {
    enable = lib.mkEnableOption "graphics" // {
      default = config.dotfyls.desktops.enable;
    };
    drivers = lib.mkOption {
      type = self.lib.listOrSingleton lib.types.str;
      default = [ ];
      description = "Drivers to be used for graphics.";
    };
    earlyKMSModules = lib.mkOption {
      type = self.lib.listOrSingleton lib.types.str;
      default = [ ];
      description = ''
        Kernel modules to be used for early KMS graphics.
        For more information, see: https://wiki.archlinux.org/title/Kernel_mode_setting#Early_KMS_start.
      '';
    };
    extraPackages = self.lib.mkExtraPackagesOption "graphics";
  };

  config = lib.mkIf cfg.enable {
    dotfyls.graphics.extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl

      openh264

      vaapiVdpau

      vulkan-extension-layer
      vulkan-loader
      vulkan-validation-layers
    ];

    services.xserver.videoDrivers = cfg.drivers;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      inherit (cfg) extraPackages;
    };

    # INFO: https://wiki.archlinux.org/title/Kernel_mode_setting#Early_KMS_start
    boot.initrd.kernelModules = cfg.earlyKMSModules;
  };
}
