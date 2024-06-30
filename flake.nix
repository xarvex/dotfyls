{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    persistwd = {
      url = "gitlab:/xarvex/persistwd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "gitlab:dotfyls/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "gitlab:dotfyls/wezterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        inputs.neovim.homeManagerModules.default
        inputs.wezterm.homeManagerModules.default

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
