{ inputs, pkgs, specialArgs, user, ... }:

let
  mkHomeConfiguration =
    host:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./${host}/home.nix
        ../home-manager
        ../overlay
      ];
    };
in
{
  botworks-virtualized = mkHomeConfiguration "botworks-virtualized";
}
