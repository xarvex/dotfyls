{ inputs, self }:

let
  mkPkgs =
    {
      nixpkgs,
      system,
      unfreePkgs,
    }:
    import nixpkgs {
      inherit system;

      config = {
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfreePkgs;
      };
    };

  mkOverlaysModule = overlays: {
    nixpkgs = {
      inherit overlays;
    };
  };

  commonHomeManagerModules = host: user: [
    ../home-manager
    ../hosts/${host}/home.nix

    {
      home = {
        username = user;
        homeDirectory = "/home/${user}";
      };
    }
  ];
in
{
  mkNixosConfiguration =
    host:
    {
      home-manager,
      id,
      nixpkgs,
      overlays,
      system,
      unfreePkgs,
      user,
      ...
    }:
    let
      inherit (nixpkgs) lib;
    in
    lib.nixosSystem rec {
      pkgs = mkPkgs { inherit nixpkgs system unfreePkgs; };

      specialArgs = {
        inherit inputs self user;
      };

      modules = [
        home-manager.nixosModules.home-manager

        ../nixos
        ../hosts/${host}
        ../hosts/${host}/hardware.nix

        (mkOverlaysModule overlays)

        {
          networking = {
            hostId = id;
            hostName = host;
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs;

            users.${user}.imports = commonHomeManagerModules host user;
          };
        }

        (lib.mkAliasOptionModule [ "usr" ] [
          "users"
          "users"
          user
        ])
        (lib.mkAliasOptionModule [ "hm" ] [
          "home-manager"
          "users"
          user
        ])
      ];
    };

  mkHomeManagerConfiguration =
    host:
    {
      home-manager,
      nixpkgs,
      overlays,
      system,
      unfreePkgs,
      user,
      ...
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs { inherit nixpkgs system unfreePkgs; };

      extraSpecialArgs = {
        inherit inputs self;
      };

      modules = [
        (mkOverlaysModule overlays)
      ] ++ commonHomeManagerModules host user;
    };
}
