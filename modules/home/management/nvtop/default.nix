{
  config,
  lib,
  osConfig ? null,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.management;
  cfg = cfg'.nvtop;

  getModule = pkg: (builtins.head (lib.splitString ":" pkg.meta.position));
in
{
  options.dotfyls.management.nvtop = {
    enable = lib.mkEnableOption "NVTOP" // {
      default = true;
    };
    package =
      lib.mkPackageOption pkgs "NVTOP" {
        default = [
          "nvtopPackages"
          "full"
        ];
      }
      // {
        default = pkgs.callPackage (getModule pkgs.nvtopPackages.full) { };
      };
    finalPackage = self.lib.mkFinalPackageOption "NVTOP" // {
      default = pkgs.callPackage (getModule cfg.package) cfg.families;
    };

    families =
      let
        mkFamilyOption =
          family: drivers:
          lib.mkEnableOption "${family}"
          // (lib.optionalAttrs (osConfig != null) {
            default = builtins.any (
              driver: builtins.elem driver drivers
            ) osConfig.services.xserver.videoDrivers;
          });
      in
      {
        intel = mkFamilyOption "Intel" [
          "i915"
          "xe"
        ];
        nvidia = mkFamilyOption "Nvidia" [ "nvidia" ];
      };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = [ (self.lib.getCfgPkg cfg) ]; };
}
