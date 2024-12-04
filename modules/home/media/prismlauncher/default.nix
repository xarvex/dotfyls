{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.media;
  cfg = cfg'.prismlauncher;
in
{
  options.dotfyls.media.prismlauncher = {
    enable = lib.mkEnableOption "Prism Launcher" // {
      default = config.dotfyls.desktops.enable;
    };
    package = lib.mkPackageOption pkgs "Prism Launcher" { default = "prismlauncher"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/PrismLauncher".persist = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
