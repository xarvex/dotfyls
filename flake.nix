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

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

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
            persistwd.nixosModules.persistwd
          ];
          homeManagerModules = with inputs; [
            dotfyls-neovim.homeManagerModules.neovim
            dotfyls-wezterm.homeManagerModules.wezterm
          ];

          overlays = [ self.overlays.default ];

          unfreePkgs = [
            "discord"
            "spotify"
          ];
        in
        {
          botworks-virtualized = {
            inherit home-manager homeManagerModules nixosModules nixpkgs overlays unfreePkgs user;

            system = "x86_64-linux";
          };
        };

      nixosHosts = {
        inherit (hosts)
          botworks-virtualized;
      };
      homeManagerHosts = {
        inherit (hosts)
          botworks-virtualized;
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs self.lib.system.mkNixosConfiguration nixosHosts
        # Keep installer separate for now.
        // { installer = lib.nixosSystem { modules = [ ./hosts/installer ]; }; };
      homeConfigurations = builtins.mapAttrs self.lib.system.mkHomeConfiguration homeManagerHosts;

      overlays =
        let
          overlays = [
            "fastfetch"
            "wezterm"
          ];
        in
        lib.genAttrs overlays (overlay: final: prev: { ${overlay} = import ./overlays/${overlay} final prev; })
        # WARNING: later elements replace duplicates, however will not occur thanks to above's unique keys
        // { default = final: prev: lib.mergeAttrsList (lib.map (overlay: self.overlays.${overlay} final prev) overlays); };

      lib = import ./lib;
    };
}
