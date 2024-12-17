{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.fzf;
in
{
  imports = [ (self.lib.mkAliasPackageModule [ "dotfyls" "programs" "fzf" ] [ "programs" "fzf" ]) ];

  options.dotfyls.programs.fzf.enable = lib.mkEnableOption "fzf" // {
    default = true;
  };

  config = lib.mkIf cfg.enable { programs.fzf.enable = true; };
}
