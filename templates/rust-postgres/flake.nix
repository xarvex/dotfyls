{
  inputs = {
    devenv.url = "github:cachix/devenv";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { flake-parts, nixpkgs, self, systems, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];

      systems = import systems;

      perSystem = { pkgs, system, ... }:
        let
          inherit (nixpkgs) lib;

          manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
        in
        {
          packages = rec {
            default = name;

            name = pkgs.rustPlatform.buildRustPackage rec {
              inherit (manifest) version;

              pname = manifest.name;

              src = pkgs.lib.cleanSource ./.;
              cargoLock.lockFile = ./Cargo.lock;

              meta = {
                inherit (manifest) description;

                homepage = manifest.repository;
                license = lib.licenses.mit;
                maintainers = with lib.maintainers; [ xarvex ];
                mainProgram = pname;
                platforms = lib.platforms.linux;
              };
            };
          };

          devenv.shells = rec {
            default = name;

            name = {
              dotenv.disableHint = true;

              packages = with pkgs; [
                cargo-expand
                cargo-msrv
                cargo-udeps
                cargo-update

                sqlx-cli
              ];

              languages.rust = {
                enable = true;
                channel = "stable";
              };

              services.postgres.enable = true;
            };
          };
        };
    };
}
