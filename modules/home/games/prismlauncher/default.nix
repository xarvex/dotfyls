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
    dotfyls = {
      file.".local/share/PrismLauncher".persist = true;

      mime-apps = {
        extraSchemes = {
          curseforge = "prismlauncher.desktop";
          prismlauncher = "prismlauncher.desktop";
        };
        extraAssociations."application/x-modrinth-modpack+zip" = "prismlauncher.desktop";
      };
    };

    home.packages = with pkgs; [ prismlauncher ];
  };
}
