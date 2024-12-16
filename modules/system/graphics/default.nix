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

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "graphics"
      ]
      {
        name = "provider";
        default = "intel";
        description = "Graphics provider to use.";
      }
    )
  ];

  options.dotfyls.graphics = {
    enable = lib.mkEnableOption "graphics" // {
      default = config.dotfyls.desktops.enable;
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

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      inherit (cfg) extraPackages;
    };
  };
}
