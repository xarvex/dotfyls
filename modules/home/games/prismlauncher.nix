{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.games;
  cfg = cfg'.prismlauncher;
in
{
  options.dotfyls.games.prismlauncher.enable = lib.mkEnableOption "Prism Launcher" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".local/share/PrismLauncher".cache = true;
      ".local/share/PrismLauncher/instances" = {
        persist = true;
        sync = {
          enable = true;
          rescan = 0;
          watch.delay = 15 * 60;
          order = "newestFirst";
        };
      };
    };

    home.packages = with pkgs; [ prismlauncher ];

    xdg.mimeApps.associations.removed."application/zip" = "org.prismlauncher.PrismLauncher.desktop";
  };
}
