{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.prismlauncher;
in
{
  options.dotfyls.games.prismlauncher = {
    enable = lib.mkEnableOption "Prism Launcher" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "Prism Launcher" { default = "prismlauncher"; };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/PrismLauncher".persist = true;

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
