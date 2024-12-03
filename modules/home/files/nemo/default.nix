{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.files.nemo;
in
{
  options.dotfyls.files.nemo = {
    enable = lib.mkEnableOption "Nemo" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Nemo" { default = "nemo-with-extensions"; };
    extraPackages = self.lib.mkExtraPackagesOption "Nemo" // {
      default = with pkgs; [ webp-pixbuf-loader ];
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/thumbnails" = {
      mode = "0700";
      cache = true;
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ] ++ cfg.extraPackages;
  };
}
