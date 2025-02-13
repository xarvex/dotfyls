{
  description = "dotfyls";

  inputs = {
    devenv.url = "github:cachix/devenv";

    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    dotpanel = {
      url = "git+https://codeberg.org/xarvex/dotpanel?submodules=1";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
        nix2container.follows = "nix2container";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-master.url = "github:NixOS/nixpkgs";

    persistwd = {
      url = "gitlab:xarvex/persistwd";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
        nix2container.follows = "nix2container";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    systems.url = "github:nix-systems/default";

    wherenver = {
      url = "gitlab:xarvex/wherenver";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
        nix2container.follows = "nix2container";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    yubigen = {
      url = "gitlab:xarvex/yubigen";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
        nix2container.follows = "nix2container";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
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
      imports = [ inputs.devenv.flakeModule ];

      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        {
          packages = import ./packages { inherit pkgs; };

          devenv.shells = import ./devenv { inherit inputs lib pkgs; };

          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        inherit (import ./modules { inherit inputs lib self; })
          nixosConfigurations
          homeConfigurations
          nixosModules
          homeManagerModules
          ;

        overlays = import ./overlays { inherit inputs lib self; };

        templates = import ./templates;

        lib = import ./lib { inherit lib; };
      };
    };
}
