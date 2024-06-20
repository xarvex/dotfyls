{
  description = "Personal Neovim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    systems.url = "github:nix-systems/default";
  };

  outputs = { flake-parts, nixpkgs, systems, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { system, ... }:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.wezterm; # will be bundled with config
      };

    flake.homeManagerModules.default = ({ config, lib, pkgs, ... }: lib.mkIf config.programs.wezterm.enable {
      xdg.configFile.wezterm = {
        recursive = true;
        source = ./.;
      };
    });
  };
}
