{
  description = "C";

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
    inputs@{ flake-parts, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];

      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        {
          devenv.shells = rec {
            default = name;

            name = {
              devenv.root =
                let
                  devenvRoot = builtins.readFile inputs.devenv-root.outPath;
                in
                # If not overridden (/dev/null), --impure is necessary.
                lib.mkIf (devenvRoot != "") devenvRoot;

              name = "C";

              packages = with pkgs; [
                clang-tools
                codespell
              ];

              languages = {
                c.enable = true;
                nix.enable = true;
              };

              pre-commit.hooks = {
                clang-format.enable = true;
                deadnix.enable = true;
                flake-checker.enable = true;
                nixfmt-rfc-style.enable = true;
                statix.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
