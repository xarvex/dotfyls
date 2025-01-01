{
  description = "dotfyls";

  inputs = {
    devenv.url = "github:cachix/devenv";

    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    dotfyls-wezterm = {
      url = "gitlab:dotfyls/wezterm";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
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
      home-manager,
      nixpkgs,
      self,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      hosts =
        let
          user = "xarvex"; # Change this if you aren't me!

          unfreePkgs = [
            "discord"
            "nvidia-settings"
            "nvidia-x11"
            "obsidian"
            "spotify"
            "steam"
            "steam-original"
            "steam-run"
            "steam-unwrapped"
            "vintagestory"
            "zsh-abbr"
          ];

          defaultHost = id: system: {
            inherit
              home-manager
              id
              nixpkgs
              system
              unfreePkgs
              user
              ;
          };
        in
        {
          artemux = defaultHost "fd9daca2" "x86_64-linux";
          matrix = defaultHost "3bb44cc9" "x86_64-linux";
          pioneer = defaultHost "3540bf30" "x86_64-linux";
          sentinel = defaultHost "ef01cd45" "x86_64-linux";
        };

      nixosHosts = {
        inherit (hosts)
          artemux
          matrix
          pioneer
          sentinel
          ;
      };
      homeManagerHosts = {
        inherit (hosts)
          artemux
          matrix
          pioneer
          sentinel
          ;
      };
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
        nixosConfigurations =
          builtins.mapAttrs self.lib.mkNixosConfiguration nixosHosts
          # Keep installer separate for now.
          // {
            installer = lib.nixosSystem {
              specialArgs = { inherit self; };

              modules = [ ./modules/hosts/installer ];
            };
          };
        homeConfigurations = builtins.mapAttrs self.lib.mkHomeManagerConfiguration homeManagerHosts;

        inherit (import ./modules { inherit lib; }) nixosModules homeManagerModules;

        overlays = import ./overlays { inherit lib self; };

        templates = import ./templates;

        lib = import ./lib { inherit inputs lib self; };
      };
    };
}
