{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.ripgrep;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "programs" "ripgrep" ] [ "programs" "ripgrep" ])
  ];

  options.dotfyls.programs.ripgrep.enable = lib.mkEnableOption "ripgrep" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;

      arguments = [
        "--hidden"
        "--glob=!.git/*"
        "--glob=!*/.git/*"
        "--smart-case"
      ];
    };
  };
}
