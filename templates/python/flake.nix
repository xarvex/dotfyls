{
  description = "Python";

  inputs = {
    devenv.url = "github:cachix/devenv";

    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs =
    { flake-parts, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];

      systems = import inputs.systems;

      perSystem = _: {
        devenv.shells = rec {
          default = python;

          python = {
            devenv.root =
              let
                devenvRoot = builtins.readFile inputs.devenv-root.outPath;
              in
              # If not overriden (/dev/null), --impure is necessary.
              lib.mkIf (devenvRoot != "") devenvRoot;

            name = "Python";

            languages = {
              nix.enable = true;
              python = {
                enable = true;
                venv = {
                  enable = true;
                  quiet = true;
                };
              };
            };

            pre-commit.hooks = {
              deadnix.enable = true;
              flake-checker.enable = true;
              nixfmt-rfc-style.enable = true;
              pyright.enable = true;
              ruff.enable = true;
              ruff-format.enable = true;
              statix.enable = true;
            };
          };
        };
      };
    };
}
