{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.direnv;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "development"
        "direnv"
      ]
      [
        "programs"
        "direnv"
      ]
    )
  ];

  options.dotfyls.development.direnv.enable = lib.mkEnableOption "direnv" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".local/share/direnv".persist = true;
      ".cache/direnv/layouts".cache = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      wherenver.enable = true;

      config = {
        strict_env = true;
        hide_env_diff = true;
      };
      stdlib = builtins.readFile ./stdlib.bash;
    };
  };
}
