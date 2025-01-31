{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.nix.index;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.dotfyls.nix.index.enable = lib.mkEnableOption "nix-index" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/nix-index".cache = true;

    programs.nix-index = {
      enable = true;
      package = inputs.nix-index-database.packages.${pkgs.system}.nix-index-with-db.override {
        inherit (pkgs) nix-index-unwrapped;
      };
    };
  };
}
