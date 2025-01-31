{ config, lib, ... }:

let
  cfg' = config.dotfyls.development.git;
  cfg = cfg'.difftastic;
in
{
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
