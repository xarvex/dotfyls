{
  description = "dotfyls";

  inputs = {
    devenv.url = "github:cachix/devenv";

    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    dotfyls-firefox = {
      url = "gitlab:dotfyls/firefox";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    dotfyls-neovim = {
      url = "gitlab:dotfyls/neovim";
      inputs = {
        devenv.follows = "devenv";
        flake-parts.follows = "flake-parts";
        nix2container.follows = "nix2container";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
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
          botworks = defaultHost "ef01cd45" "x86_64-linux";
          botworks-mobilized = defaultHost "fd9daca2" "x86_64-linux";
          botworks-pioneer = defaultHost "3540bf30" "x86_64-linux";
          botworks-virtualized = defaultHost "3bb44cc9" "x86_64-linux";
        };

      nixosHosts = {
        inherit (hosts)
          botworks
          botworks-mobilized
          botworks-pioneer
          botworks-virtualized
          ;
      };
      homeManagerHosts = {
        inherit (hosts)
          botworks
          botworks-mobilized
          botworks-pioneer
          botworks-virtualized
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

          devenv.shells = rec {
            default = dotfyls;

            dotfyls = {
              devenv.root =
                let
                  devenvRoot = builtins.readFile inputs.devenv-root.outPath;
                in
                # If not overridden (/dev/null), --impure is necessary.
                lib.mkIf (devenvRoot != "") devenvRoot;

              name = "dotfyls";

              packages = with pkgs; [
                codespell
              ];

              languages = {
                nix.enable = true;
                shell.enable = true;
              };

              pre-commit.hooks = {
                deadnix.enable = true;
                flake-checker.enable = true;
                nixfmt-rfc-style.enable = true;
                statix.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        nixosConfigurations =
          builtins.mapAttrs self.lib.mkNixosConfiguration nixosHosts
          # Keep installer separate for now.
          // {
            installer = lib.nixosSystem { modules = [ ./hosts/installer ]; };
          };
        homeConfigurations = builtins.mapAttrs self.lib.mkHomeManagerConfiguration homeManagerHosts;

        inherit (import ./modules { inherit lib; }) nixosModules homeManagerModules;

        overlays = import ./overlays { inherit lib self; };

        templates = import ./templates;

        lib = import ./lib { inherit inputs lib self; };
      };
    };
}
