{ inputs, pkgs, ... }:

let
  mkHomeConfiguration =
    host:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        inputs.neovim.homeManagerModules.default
        ./${host}/home.nix
        ../home-manager
        ../overlay
      ];
    };
in
{
  botworks-virtualized = mkHomeConfiguration "botworks-virtualized";
}
