{
  description = "Personal WezTerm";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs = { flake-parts, nixpkgs, systems, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { system, ... }:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = rec {
          default = wezterm;

          wezterm = pkgs.wezterm; # will be bundled with config
        };
      };

    flake.homeManagerModules = rec {
      default = wezterm;

      wezterm = ({ config, lib, pkgs, ... }: lib.mkIf config.programs.wezterm.enable {
        home.packages = with pkgs; [
          # JetBrains Mono style
          (iosevka-bin.override { variant = "SGr-IosevkaTermSS14"; })
        ];

        xdg.configFile.wezterm = {
          recursive = true;
          source = ./.;
        };
      });
    };
  };
}
