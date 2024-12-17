{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.development.git;
  cfg = cfg'.difftastic;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "development" "git" "difftastic" ]
      [ "programs" "git" "difftastic" ]
    )
  ];

  options.dotfyls.development.git.difftastic.enable = lib.mkEnableOption "difftastic" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.git.difftastic = {
      enable = true;

      background = "dark";
    };
  };
}
