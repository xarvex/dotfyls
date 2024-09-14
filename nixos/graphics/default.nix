{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.graphics;
  hmCfg = config.hm.dotfyls.graphics;
in
{
  imports = [
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
      {
        intel = "Intel";
        nvidia = "NVIDIA";
      }
    )

    (self.lib.mkCommonModules
      [
        "dotfyls"
        "graphics"
        "graphics"
      ]
      (graphics: _: {
        driver = lib.mkOption {
          type = lib.types.str;
          description = "Driver used for ${graphics.name}.";
        };
        extraPackages = self.lib.mkExtraPackagesOption "graphics for ${graphics.name}";
      })
      {
        amd = {
          name = "AMD";
          specialArgs = {
            driver.default = "amdgpu";
          };
        };
        intel = {
          name = "Intel";
          specialArgs = {
            driver.default = "i915";
            extraPackages.default = with pkgs; [
              intel-media-driver
              intel-media-sdk
              intel-vaapi-driver

              vpl-gpu-rt
            ];
          };
        };
        nvidia = {
          name = "NVIDIA";
          specialArgs = {
            driver.default = "nvidia";
            extraPackages.default = with pkgs; [
              egl-wayland

              libglvnd
            ];
          };
        };
      }
    )
  ];

  options.dotfyls.graphics = {
    enable = lib.mkEnableOption "graphics" // {
      default = hmCfg.enable;
    };
    blacklistCompeting = lib.mkEnableOption "blacklisting competing graphics drivers" // {
      default = true;
    };
    extraPackages = self.lib.mkExtraPackagesOption "graphics" // {
      default = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl

        vaapiVdpau

        vulkan-extension-layer
        vulkan-loader
        vulkan-validation-layers
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = with cfg; [ selected.driver ];

    boot.blacklistedKernelModules = lib.mkIf cfg.blacklistCompeting (
      builtins.map (graphics: graphics.driver) (
        builtins.attrValues (builtins.removeAttrs cfg.graphics [ cfg.provider ])
      )
    );

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with cfg; extraPackages ++ selected.extraPackages;
    };
  };
}
