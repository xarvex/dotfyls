{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.eza;

  iCfg = config.dotfyls.icon;
in
{
  options.dotfyls.shells.programs.eza = {
    enable = lib.mkEnableOption "eza" // {
      default = cfg'.enableFun;
    };
    package = lib.mkPackageOption pkgs "eza" { };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ (self.lib.getCfgPkg cfg) ];

      shellAliases = {
        "l." = "eza -d .* --icons auto";
        ll = "eza -la --git";
        ls = "eza --icons auto";
        tree = "eza -T --icons auto -L2";

        watchdir = "watch -cn1 -x eza -T --color always -L2";
      };
    };

    xdg.configFile."eza/theme.yml".source = pkgs.runCommand "dotfyls-eza-theme" {
      buildInputs = with pkgs; [ yj ];
      json = builtins.toJSON {
        filenames = builtins.mapAttrs (_: icon: {
          icon.glyph = lib.trimWith { end = true; } icon;
        }) iCfg.byName;
        extensions = builtins.mapAttrs (_: icon: {
          icon.glyph = lib.trimWith { end = true; } icon;
        }) iCfg.byExtension;
      };
      passAsFile = [ "json" ];
    } ''yj -jy <"''${jsonPath}" >"''${out}"'';
  };
}
