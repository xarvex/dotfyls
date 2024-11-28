{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.nemo;
in
{
  options.dotfyls.media.nemo = {
    enable = lib.mkEnableOption "Nemo" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Nemo" { default = "nemo-with-extensions"; };
    extraPackages = self.lib.mkExtraPackagesOption "Nemo" // {
      default = with pkgs; [ webp-pixbuf-loader ];
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.files.cacheDirectories = [ ".cache/thumbnails" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ] ++ cfg.extraPackages;
  };
}
