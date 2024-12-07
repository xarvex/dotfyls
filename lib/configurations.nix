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
      config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfreePkgs;
    };

  commonHomeManagerModules = host: [
    ../modules/home
    ../modules/hosts/${host}/home.nix
  ];
in
{
  mkNixosConfiguration =
    host:
    {
      home-manager,
      id,
      nixpkgs,
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

      specialArgs = { inherit inputs self user; };

      modules = [
        home-manager.nixosModules.home-manager

        ../modules/system
        ../modules/hosts/${host}/hardware.nix
        ../modules/hosts/${host}/system.nix

        {
          networking = {
            hostId = id;
            hostName = host;
          };

          home-manager = {
            extraSpecialArgs = specialArgs;
            users.${user}.imports = commonHomeManagerModules host;
          };
        }
      ];
    };

  mkHomeManagerConfiguration =
    host:
    {
      home-manager,
      nixpkgs,
      system,
      unfreePkgs,
      user,
      ...
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs { inherit nixpkgs system unfreePkgs; };

      extraSpecialArgs = { inherit inputs self user; };
      modules = commonHomeManagerModules host;
    };
}
