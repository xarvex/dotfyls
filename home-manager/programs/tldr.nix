{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.tldr;
in
{
  options.dotfyls.programs.tldr = {
    enable = lib.mkEnableOption "tldr" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "tlrc" { };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".cache/tlrc" ];

    home.packages = [ (self.lib.getCfgPkg cfg) ];
  };
}
