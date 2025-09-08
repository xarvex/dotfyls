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
  ];

  options.dotfyls.graphics = {
    enable = lib.mkEnableOption "graphics" // {
      default = config.dotfyls.desktops.enable;
    };
    provider = lib.mkOption {
      type = lib.types.enum [
        "intel"
        "nvidia"
      ];
      example = "intel";
      description = "Graphics provider to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.graphics = self.lib.enableSelected cfg.provider [
      "intel"
      "nvidia"
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        openh264

        vulkan-extension-layer
        vulkan-loader
        vulkan-validation-layers
      ];
    };
  };
}
