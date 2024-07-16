{
  description = "Xarvex's Nix configuration";

  inputs = {
    dotfyls-neovim = {
      url = "gitlab:dotfyls/neovim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    dotfyls-wezterm = {
      url = "gitlab:dotfyls/wezterm";
      inputs = {
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

    flake-parts.url = "github:hercules-ci/flake-parts";

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

    persistwd = {
      url = "gitlab:xarvex/persistwd";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    systems.url = "github:nix-systems/default";
  };

  outputs = { home-manager, nixpkgs, self, ... }@inputs:
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
            dotfyls-neovim.homeManagerModules.neovim
            dotfyls-wezterm.homeManagerModules.wezterm
            dotfyls-zsh.homeManagerModules.zsh
            nix-index-database.hmModules.nix-index
          ];

          overlays = [ self.overlays.default ];

          unfreePkgs = [
            "discord"
            "nvidia-settings"
            "nvidia-x11"
            "spotify"
          ];

          defaultHost = system: {
            inherit
              home-manager
              homeManagerModules
              nixosModules
              nixpkgs
              overlays
              system
              unfreePkgs
              user;
          };
        in
        {
          botworks = defaultHost "x86_64-linux";
          botworks-pioneer = defaultHost "x86_64-linux";
          botworks-virtualized = defaultHost "x86_64-linux";
        };

      nixosHosts = {
        inherit (hosts)
          botworks
          botworks-pioneer
          botworks-virtualized;
      };
      homeManagerHosts = {
        inherit (hosts)
          botworks
          botworks-pioneer
          botworks-virtualized;
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs self.lib.configuration.mkNixos nixosHosts
        # Keep installer separate for now.
        // { installer = lib.nixosSystem { modules = [ ./hosts/installer ]; }; };
      homeConfigurations = builtins.mapAttrs self.lib.configuration.mkHomeManager homeManagerHosts;

      overlays =
        let
          overlays = [
            "discord"
            "evil-winrm"
            "fastfetch"
            "wezterm"
          ];
        in
        lib.genAttrs overlays (overlay: final: prev: { ${overlay} = import ./overlays/${overlay} final prev; })
        # WARNING: later elements replace duplicates, however will not occur thanks to above's unique keys
        // { default = final: prev: lib.mergeAttrsList (lib.map (overlay: self.overlays.${overlay} final prev) overlays); };

      lib = import ./lib;

      # Aggregate for export convenience.
      homeManagerModules = with inputs; {
        inherit (dotfyls-neovim.homeManagerModules) neovim;
        inherit (dotfyls-wezterm.homeManagerModules) wezterm;
        inherit (dotfyls-zsh.homeManagerModules) zsh;
      };
    };
}
