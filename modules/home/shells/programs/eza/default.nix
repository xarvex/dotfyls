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
in
{
  options.dotfyls.shells.programs.eza = {
    enable = lib.mkEnableOption "eza" // {
      default = cfg'.enableFun;
    };
    package = lib.mkPackageOption pkgs "eza" { };
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      "l." = "eza -d .* --icons auto";
      ll = "eza -la --git";
      ls = "eza --icons auto";
      tree = "eza -T --icons auto -L2";

      watchdir = "watch -cn1 -x eza -T --color always -L2";
    };

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
