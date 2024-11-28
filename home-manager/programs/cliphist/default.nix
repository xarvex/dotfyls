{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.cliphist;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "cliphist"
      ]
      [
        "services"
        "cliphist"
      ]
    )
  ];

  options.dotfyls.programs.cliphist.enable = lib.mkEnableOption "cliphist";

  config = lib.mkIf cfg.enable {
    dotfyls.files.cacheDirectories = [ ".cache/cliphist" ];

    services.cliphist.enable = true;
  };
}
