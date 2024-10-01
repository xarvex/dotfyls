{
  description = "JavaScript";

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
          default = javascript;

          javascript = {
            devenv.root =
              let
                devenvRoot = builtins.readFile inputs.devenv-root.outPath;
              in
              # If not overridden (/dev/null), --impure is necessary.
              lib.mkIf (devenvRoot != "") devenvRoot;

            name = "JavaScript";

            languages = {
              javascript = {
                enable = true;
                pnpm = {
                  enable = true;
                  install.enable = true;
                };
              };
              nix.enable = true;
              typescript.enable = true;
            };

            pre-commit.hooks = {
              deadnix.enable = true;
              eslint.enable = true;
              flake-checker.enable = true;
              nixfmt-rfc-style.enable = true;
              prettier.enable = true;
              statix.enable = true;
            };
          };
        };
      };
    };
}
