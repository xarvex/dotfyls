{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.vintagestory;
in
{
  options.dotfyls.media.vintagestory = {
    enable = lib.mkEnableOption "Vintage Story" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Vintage Story" { default = "vintagestory"; };
    finalPackage = self.lib.mkFinalPackageOption "Vintage Story" // {
      default = cfg.package.override {
        dotnet-runtime_7 = pkgs.dotnet-runtime_7.overrideAttrs (o: {
          src = o.src.overrideAttrs (o: {
            meta = o.meta // {
              knownVulnerabilities = [ ];
            };
          });
          meta = o.meta // {
            knownVulnerabilities = [ ];
          };
        });
      };
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/VintagestoryData".cache = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
