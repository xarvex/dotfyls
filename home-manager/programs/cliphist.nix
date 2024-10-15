{
  config,
  inputs,
  lib,
  pkgs,
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
    dotfyls.persist.cacheDirectories = [ ".cache/cliphist" ];

    services.cliphist = {
      enable = true;
      package = inputs.nixpkgs_cliphist.legacyPackages.${pkgs.system}.cliphist;
    };
  };
}
