{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.eza;

  iCfg = config.dotfyls.icon;
in
{
  options.dotfyls.shells.programs.eza.enable = lib.mkEnableOption "eza" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [ eza ];

      shellAliases = {
        "l." = "eza --group-directories-first --icons auto -d .*";
        ll = "eza --group-directories-first --icons auto -la --git";
        ls = "eza --group-directories-first --icons auto";
        tree = "eza --group-directories-first --icons auto -T";

        watchdir = "watch -cn1 -x eza --group-directories-first -T --color always";
      };
    };

    xdg.configFile."eza/theme.yml".source =
      pkgs.runCommandNoCCLocal "eza-theme"
        {
          nativeBuildInputs = with pkgs; [ yj ];

          json = builtins.toJSON {
            filenames = builtins.mapAttrs (_: icon: {
              icon.glyph = lib.trimWith { end = true; } icon;
            }) iCfg.byName;
            extensions = builtins.mapAttrs (_: icon: {
              icon.glyph = lib.trimWith { end = true; } icon;
            }) iCfg.byExtension;
          };
          passAsFile = [ "json" ];
        }
        ''
          yj -jy <$jsonPath >$out
        '';
  };
}
