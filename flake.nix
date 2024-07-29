{
  description = "Personal Firefox";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs = { flake-parts, nixpkgs, self, systems, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { system, ... }:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # TODO
      };

    flake.homeManagerModules = rec {
      default = firefox;

      firefox = ({ config, lib, pkgs, ... }: lib.mkIf config.programs.firefox.enable {
        programs.firefox = {
          profiles.${config.home.username} = {
            extraConfig = ''
              ${builtins.readFile "${pkgs.arkenfox-userjs}/user.js"}

              ${builtins.readFile ./user-overrides.js}
            '';
          };
        };
      });
    };
  };
}
