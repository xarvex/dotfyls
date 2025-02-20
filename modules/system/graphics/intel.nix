{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.graphics;
  cfg = cfg'.graphics.intel;

  force-full-rgb = pkgs.writers.writeDash "dotfyls-intel-force-full-rgb" (
    lib.concatStrings (
      map (connector: ''
        ${lib.getExe' pkgs.libdrm "proptest"} -M i915 -D /dev/dri/card1 ${toString connector} connector 317 1
      '') cfg.forceFullRGB
    )
  );
in
{
  options.dotfyls.graphics.graphics.intel = {
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
    dotfyls.graphics = {
      drivers = lib.optional cfg.experimentalDrivers "xe" ++ [ "i915" ];
      earlyKMSModules = "i915";
      extraPackages = with pkgs; [
        intel-media-driver
        (intel-vaapi-driver.override { enableHybridCodec = true; })

        libvpl

        vpl-gpu-rt
      ];
    };

    environment.sessionVariables.ANV_VIDEO_DECODE = 1;

    services.udev.extraRules = lib.mkIf (cfg.forceFullRGB != [ ]) ''
      ACTION=="add", \
        SUBSYSTEM=="module", \
        KERNEL=="i915", \
        RUN+="${force-full-rgb}"
    '';
  };
}
