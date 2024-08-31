{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.nemo;
in
{
  options.dotfyls.programs.nemo = {
    enable = lib.mkEnableOption "Nemo" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Nemo" { default = "nemo-with-extensions"; };
    extraPackages = self.lib.mkExtraPackagesOption "Nemo" // {
      default = with pkgs; [ webp-pixbuf-loader ];
    };
  };

  config = lib.mkIf cfg.enable { home.packages = [ (self.lib.getCfgPkg cfg) ] ++ cfg.extraPackages; };
}
