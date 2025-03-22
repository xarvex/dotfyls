{
  description = "project-name";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
      };
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      self,
      ...
    }:
    let
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, system, ... }:
        let
          python = pkgs.python312;

          uv-workspace = inputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

          pythonSet =
            (pkgs.callPackage inputs.pyproject-nix.build.packages { inherit python; }).overrideScope
              (
                lib.composeManyExtensions [
                  inputs.pyproject-build-systems.overlays.default
                  (uv-workspace.mkPyprojectOverlay { sourcePreference = "wheel"; })
                  # NOTE: Put overlays here:
                  # (final: prev: {})
                ]
              );
        in
        {
          packages = rec {
            default = project-slug;
            project-slug = pkgs.callPackage ./nix/package.nix {
              inherit (inputs) pyproject-nix;
              inherit pythonSet uv-workspace;
            };
          };

          devShells = rec {
            default = project-slug;
            project-slug = import ./nix/shell.nix {
              inherit
                inputs
                lib
                pkgs
                pythonSet
                self
                uv-workspace
                ;
            };
          };

          checks.pre-commit = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              deadnix.enable = true;
              flake-checker.enable = true;
              nixfmt-rfc-style.enable = true;
              pyright = {
                enable = true;
                args =
                  let
                    virtualenv = pythonSet.mkVirtualEnv "yubigen-virtualenv" uv-workspace.deps.all;
                  in
                  [
                    "--pythonpath"
                    (lib.getExe' virtualenv "python")
                  ];
              };
              ruff.enable = true;
              ruff-format.enable = true;
              statix.enable = true;
            };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        nixosModules = rec {
          default = project-slug;
          project-slug = import ./nix/nixos.nix { inherit inputs self; };
        };

        homeModules = rec {
          default = project-slug;
          project-slug = import ./nix/home.nix { inherit inputs self; };
        };
      };
    };
}
