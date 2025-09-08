{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.nix;
in
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    self.homeModules.nix
  ];

  options.dotfyls.nix = {
    helper = lib.mkEnableOption "nh" // {
      default = true;
    };
    index = lib.mkEnableOption "nix-index" // {
      default = true;
    };
  };

  config = lib.mkMerge [
    {
      dotfyls.file = {
        ".local/share/nix".cache = true;
        ".cache/nix".cache = true;
      };

      home = {
        packages = [ self.packages.${pkgs.system}.dotfyls-nrepl ];
        sessionVariables = {
          NREPL_HOST = config.dotfyls.meta.name;
        }
        // lib.optionalAttrs (config.dotfyls.meta.location != null) {
          NREPL_FLAKE = config.dotfyls.meta.location;
        };
      };

      programs.nh = lib.mkIf cfg.helper {
        enable = true;

        flake = lib.mkIf (config.dotfyls.meta.location != null) config.dotfyls.meta.location;
      };
    }

    (lib.mkIf cfg.index {
      dotfyls.file.".cache/nix-index".cache = true;

      programs.nix-index = {
        enable = true;
        package = inputs.nix-index-database.packages.${pkgs.system}.nix-index-with-db.override {
          inherit (pkgs) nix-index-unwrapped;
        };
      };
    })
  ];
}
