{
  description = "dotfyls";

  inputs = {
    dotpanel = {
      url = "git+https://codeberg.org/xarvex/dotpanel?submodules=1";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-master.url = "github:NixOS/nixpkgs";

    persistwd = {
      url = "git+https://codeberg.org/xarvex/persistwd";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    systems.url = "github:nix-systems/default";

    tagstudio = {
      url = "github:TagStudioDev/TagStudio";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    wherenver = {
      url = "git+https://codeberg.org/xarvex/wherenver";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    yubigen = {
      url = "git+https://codeberg.org/xarvex/yubigen";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
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
      systems = import inputs.systems;

      perSystem =
        { pkgs, system, ... }:
        {
          packages = import ./packages { inherit pkgs; };

          devShells = import ./shells { inherit pkgs self; };

          checks.pre-commit = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              deadnix.enable = true;
              flake-checker.enable = true;
              nixfmt-rfc-style.enable = true;
              statix.enable = true;
              stylua.enable = true;
            };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        inherit (import ./modules { inherit inputs lib self; })
          nixosConfigurations
          homeConfigurations
          nixosModules
          homeModules
          ;

        overlays = import ./overlays { inherit inputs lib self; };

        templates = import ./templates;

        lib = import ./lib { inherit lib; };
      };
    };
}
