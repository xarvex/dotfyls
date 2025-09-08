{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.management.monitor;
  cfg = cfg'.nvtop;

  getModule = pkg: (builtins.head (lib.splitString ":" pkg.meta.position));
in
{
  options.dotfyls.management.monitor.nvtop = {
    enable = lib.mkEnableOption "NVTOP" // {
      default = config.dotfyls.graphics.enable;
    };

    families =
      let
        mkFamilyOption =
          family: drivers:
          lib.mkEnableOption family
          // {
            default =
              osConfig != null
              && builtins.any (driver: builtins.elem driver drivers) osConfig.services.xserver.videoDrivers;
          };
      in
      {
        intel = mkFamilyOption "Intel" [
          "i915"
          "xe"
        ];
        nvidia = mkFamilyOption "Nvidia" [ "nvidia" ];
      };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = [ (pkgs.callPackage (getModule pkgs.nvtopPackages.full) cfg.families) ];
  };
}
