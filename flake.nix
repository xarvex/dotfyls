{
  description = "Xarvex's Nix configuration";

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

    dotfyls-zsh = {
      url = "gitlab:dotfyls/zsh";
      inputs = {
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
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
  };

  outputs =
    {
      flake-parts,
      home-manager,
      nixpkgs,
      self,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      hosts =
        let
          user = "xarvex"; # Change this if you aren't me!

          nixosModules = with inputs; [
            impermanence.nixosModules.impermanence
            nix-index-database.nixosModules.nix-index
            persistwd.nixosModules.persistwd
          ];
          homeManagerModules = with inputs; [
            dotfyls-firefox.homeManagerModules.firefox
            dotfyls-neovim.homeManagerModules.neovim
            dotfyls-wezterm.homeManagerModules.wezterm
            dotfyls-zsh.homeManagerModules.zsh
            nix-index-database.hmModules.nix-index
            wherenver.homeManagerModules.wherenver
          ];

          overlays = [ self.overlays.default ];

          unfreePkgs = [
            "discord"
            "nvidia-settings"
            "nvidia-x11"
            "obsidian"
            "spotify"
            "steam"
            "steam-original"
            "steam-run"
          ];

          defaultHost = id: system: {
            inherit
              home-manager
              homeManagerModules
              id
              nixosModules
              nixpkgs
              overlays
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
          devenv.shells = rec {
            default = dotfyls;

            dotfyls = {
              devenv.root =
                let
                  devenvRoot = builtins.readFile inputs.devenv-root.outPath;
                in
                # If not overriden (/dev/null), --impure is necessary.
                lib.mkIf (devenvRoot != "") devenvRoot;

              name = "dotfyls";

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

        # Aggregate for export convenience.
        homeManagerModules = with inputs; {
          inherit (dotfyls-firefox.homeManagerModules) firefox;
          inherit (dotfyls-neovim.homeManagerModules) neovim;
          inherit (dotfyls-wezterm.homeManagerModules) wezterm;
          inherit (dotfyls-zsh.homeManagerModules) zsh;
        };

        overlays =
          let
            overlays = [
              "bat-extras"
              "discord"
              "dotfyls"
              "evil-winrm"
              "fastfetch"
              "wezterm"
            ];
          in
          lib.genAttrs overlays (
            overlay: final: prev: { ${overlay} = import ./overlays/${overlay} final prev; }
          )
          # WARNING: later elements replace duplicates, however will not occur thanks to above's unique keys
          // {
            default =
              final: prev: lib.mergeAttrsList (lib.map (overlay: self.overlays.${overlay} final prev) overlays);
          };

        templates = import ./templates;

        lib = import ./lib { inherit inputs lib self; };
      };
    };
}
