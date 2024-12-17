{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.thefuck;
in
{
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "programs" "thefuck" ] [ "programs" "thefuck" ])
  ];

  options.dotfyls.programs.thefuck.enable = lib.mkEnableOption "The Fuck" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.thefuck.enable = true;

    xdg.configFile."thefuck/settings.py".source = ./settings.py;
  };
}
