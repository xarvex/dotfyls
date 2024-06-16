{ inputs, lib, pkgs, pkgs-unstable, specialArgs, user, ... }:

let
  mkNixosConfiguration =
    host:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // { inherit host pkgs-unstable user; };

      modules = [
        ./${host}
        ./${host}/hardware.nix
        ../nixos
        ../overlay

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs // { inherit host pkgs-unstable user; };

            users.${user} = {
              imports = [
                ./${host}/home.nix
                ../home-manager
              ];
            };
          };
        }

        (lib.mkAliasOptionModule [ "usr" ] [ "users" "users" user ])
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])
      ];
    };
in
{
  botworks-virtualized = mkNixosConfiguration "botworks-virtualized";
}
