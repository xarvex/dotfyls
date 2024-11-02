{
  description = "Python with Poetry";

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

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

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
        { config, pkgs, ... }:
        let
          poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
        in
        {
          packages = rec {
            default = project-name;

            project-name =
              let
                pyproject = (pkgs.lib.importTOML ./pyproject.toml).tool.poetry;
              in
              poetry2nix.mkPoetryApplication {
                projectDir = ./.;
                meta = {
                  inherit (pyproject) description;

                  homepage = pyproject.repository;
                  license = lib.licenses.mit;
                  maintainers = with lib.maintainers; [ xarvex ];
                  mainProgram = pyproject.name;
                  platforms = lib.platforms.linux;
                };
              };
          };

          devenv.shells = rec {
            default = project-name;

            project-name =
              let
                cfg = config.devenv.shells.project-name;
              in
              {
                devenv.root =
                  let
                    devenvRoot = builtins.readFile inputs.devenv-root.outPath;
                  in
                  # If not overridden (/dev/null), --impure is necessary.
                  lib.mkIf (devenvRoot != "") devenvRoot;

                name = "project-name";

                packages =
                  [
                    (poetry2nix.mkPoetryEnv {
                      projectDir = ./.;
                      python = cfg.languages.python.package;
                    })
                  ]
                  ++ (with pkgs; [
                    codespell
                  ]);

                scripts.poetry-install.exec = ''
                  ${lib.getExe cfg.languages.python.poetry.package} lock --no-update
                  ${lib.getExe cfg.languages.python.poetry.package} install --only-root
                '';

                languages = {
                  nix.enable = true;
                  python = {
                    enable = true;
                    poetry.enable = true;
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

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
