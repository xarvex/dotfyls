{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.eza;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "shells" "programs" "eza" ] [ "programs" "eza" ])
  ];

  options.dotfyls.shells.programs.eza.enable = lib.mkEnableOption "eza" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      "l." = "eza -d .* --icons auto";
      ll = "eza -la --git";
      ls = "eza --icons auto";
      tree = "eza -T --icons auto -L2";

      watchdir = "watch -cn1 -x eza -T --color always -L2";
    };

    programs.eza.enable = true;
  };
}
