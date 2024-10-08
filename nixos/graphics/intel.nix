{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.graphics.graphics.intel;

  driver = if cfg.experimentalDrivers then "xe" else "i915";
in
{
  options.dotfyls.graphics.graphics.intel.experimentalDrivers =
    lib.mkEnableOption "Intel Xe graphics"
    // {
      default = true;
    };

  config = lib.mkIf cfg.enable {
    dotfyls.graphics.extraPackages = with pkgs; [
      intel-media-driver
      (intel-vaapi-driver.override { enableHybridCodec = true; })

      libvpl

      vpl-gpu-rt
    ];

    environment.sessionVariables.ANV_VIDEO_DECODE = 1;

    services.xserver.videoDrivers = [ driver ];

    boot.initrd.kernelModules = [ driver ];
  };
}
