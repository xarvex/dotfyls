{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.nix-index;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "nix-index"
      ]
      [
        "programs"
        "nix-index"
      ]
    )
  ];

  options.dotfyls.programs.nix-index.enable = lib.mkEnableOption "nix-index" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ ".cache/nix-index" ];

    programs.nix-index.enable = true;
  };
}
