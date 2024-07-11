let
  mkPkgs = { nixpkgs, system, unfreePkgs }: import nixpkgs {
    inherit system;

    config = {
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfreePkgs;
    };
  };

  mkOverlaysModule = overlays: { nixpkgs = { inherit overlays; }; };

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
  mkNixos = host: { home-manager, homeManagerModules, nixosModules, nixpkgs, overlays, system, unfreePkgs, user, ... }:
    let
      inherit (nixpkgs) lib;
    in
    lib.nixosSystem {
      pkgs = mkPkgs { inherit nixpkgs system unfreePkgs; };

      specialArgs = { inherit user; };

      modules = [
        home-manager.nixosModules.home-manager

        ../nixos
        ../hosts/${host}
        ../hosts/${host}/hardware.nix

        (mkOverlaysModule overlays)

        {
          networking.hostName = host;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.${user}.imports = commonHomeManagerModules host user ++ homeManagerModules;
          };
        }

        (lib.mkAliasOptionModule [ "usr" ] [ "users" "users" user ])
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
      ] ++ nixosModules;
    };

  mkHomeManager = host: { home-manager, homeManagerModules, nixpkgs, overlays, system, unfreePkgs, user, ... }: home-manager.lib.homeManagerConfiguration {
    pkgs = mkPkgs { inherit nixpkgs system unfreePkgs; };

    modules = [ (mkOverlaysModule overlays) ] ++ commonHomeManagerModules host user ++ homeManagerModules;
  };
}
