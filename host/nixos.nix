{ inputs, lib, pkgs, specialArgs, user, ... }:

let
  mkNixosConfiguration =
    host:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs // { inherit host user; };

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

            extraSpecialArgs = specialArgs // { inherit host user; };

            users.${user} = {
              imports = [
                inputs.neovim.homeManagerModules.default
                inputs.wezterm.homeManagerModules.default
                ./${host}/home.nix
                ../home-manager
              ];
            };
          };
        }

        (lib.mkAliasOptionModule [ "usr" ] [ "users" "users" user ])
        (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" user ])

        inputs.impermanence.nixosModules.impermanence
      ];
    };
in
{
  botworks-virtualized = mkNixosConfiguration "botworks-virtualized";
}
