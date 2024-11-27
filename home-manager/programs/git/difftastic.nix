{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.programs.git;
  cfg = cfg'.difftastic;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "git"
        "difftastic"
      ]
      [
        "programs"
        "git"
        "difftastic"
      ]
    )
  ];

  options.dotfyls.programs.git.difftastic.enable = lib.mkEnableOption "difftastic" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.git.difftastic = {
      enable = true;

      background = "dark";
    };
  };
}
