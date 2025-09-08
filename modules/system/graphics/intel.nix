{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.graphics;
  cfg = cfg'.intel;

  force-full-rgb = pkgs.writers.writeDash "dotfyls-intel-force-full-rgb" (
    lib.concatMapStringsSep "\n" (
      connector:
      "${lib.getExe' pkgs.libdrm "proptest"} -M i915 -D /dev/dri/card1 ${toString connector} connector 317 1"
    ) cfg.forceFullRGB
  );
in
{
  options.dotfyls.graphics.intel = {
    enable = lib.mkEnableOption "Intel graphics";

    experimentalDrivers = lib.mkEnableOption "Intel Xe graphics" // {
      default = true;
    };
    forceFullRGB = lib.mkOption {
      type = self.lib.listOrSingleton lib.types.int;
      default = [ ];
      description = "Display connectors (integers from proptest) to force broadcasting full RGB.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    environment.sessionVariables = {
      VDPAU_DRIVER = "va_gl";

      ANV_VIDEO_DECODE = 1;
      ANV_DEBUG = "video-decode,video-encode";
    };

    services = {
      xserver.videoDrivers = lib.optional cfg.experimentalDrivers "xe" ++ [ "i915" ];
      udev.extraRules = lib.mkIf (cfg.forceFullRGB != [ ]) ''
        ACTION=="add", \
          SUBSYSTEM=="module", \
          KERNEL=="i915", \
          RUN+="${force-full-rgb}"
      '';
    };

    hardware = {
      graphics.extraPackages = with pkgs; [
        intel-media-driver
        (intel-vaapi-driver.override { enableHybridCodec = true; })

        libva
        libvdpau-va-gl
        libvpl

        vpl-gpu-rt
      ];
      intel-gpu-tools.enable = true;
    };

    boot.initrd.kernelModules = lib.optionals (!config.boot.plymouth.enable) [ "i915" ];
  };
}
