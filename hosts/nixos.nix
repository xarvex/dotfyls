{ inputs, lib, pkgs, user, ... }:

let
  specialArgs = { inherit user; };
  mkNixosConfiguration =
    host:
    lib.nixosSystem {
      inherit pkgs;

      specialArgs = specialArgs;

      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
        inputs.persistwd.nixosModules.default

        ./${host}
        ./${host}/hardware.nix
        ../nixos
        ../overlays

        {
          networking.hostName = host;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs;

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
      ];
    };
in
{
  botworks-virtualized = mkNixosConfiguration "botworks-virtualized";
}
