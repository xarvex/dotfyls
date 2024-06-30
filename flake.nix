{
  description = "Nixos config flake";

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

  outputs = { nixpkgs, ... }@inputs:
    let
      # Change this if you aren't me!
      user = "xarvex";

      nixosHosts = {
        botworks-virtualized = "x86_64-linux";
      };
      homeManagerHosts = {
        botworks-virtualized = "x86_64-linux";
      };

      unfreePkgs = [
        "discord"
        "spotify"
      ];

      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfreePkgs;

      # Must not only be common, but common place!
      commonModules = host: [
        inputs.dotfyls-neovim.homeManagerModules.default
        inputs.dotfyls-wezterm.homeManagerModules.default

        ./home-manager
        ./hosts/${host}/home.nix
      ];

      mkNixosConfiguration = host: system: nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          inherit system;

          config = { inherit allowUnfreePredicate; };
        };

        specialArgs = { inherit user; };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.impermanence.nixosModules.impermanence
          inputs.persistwd.nixosModules.default

          ./nixos
          ./overlays
          ./hosts/${host}
          ./hosts/${host}/hardware.nix

          {
            networking.hostName = host;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = { inherit user; };

              users.${user}.imports = commonModules host;
            };
          }

          (nixpkgs.lib.mkAliasOptionModule [ "usr" ] [ "users" "users" user ])
          (nixpkgs.lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
        ];
      };

      mkHomeConfiguration = host: system: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;

          config = { inherit allowUnfreePredicate; };
        };

        extraSpecialArgs = { inherit user; };

        modules = commonModules host ++ [
          ../overlays
        ];
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkNixosConfiguration nixosHosts;
      homeConfigurations = builtins.mapAttrs mkHomeConfiguration homeManagerHosts;
    };
}
