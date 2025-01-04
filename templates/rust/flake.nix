{
  description = "Rust";

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

    systems.url = "github:nix-systems/default-linux";
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
      imports = [ inputs.devenv.flakeModule ];

      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        {
          packages = rec {
            default = project-name;
            project-name = pkgs.callPackage ./nix/package.nix { };
          };

          devenv.shells = rec {
            default = project-name;
            project-name = import ./nix/devenv.nix { inherit inputs lib pkgs; };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        nixosModules = rec {
          default = project-name;
          project-name = import ./nix/nixos.nix { inherit self; };
        };

        homeManagerModules = rec {
          default = project-name;
          project-name = import ./nix/home-manager.nix { inherit self; };
        };
      };
    };
}
