{
  description = "Rust with Cargo workspaces";

  inputs = {
    devenv.url = "github:cachix/devenv";

    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default-linux";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];

      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        let
          manifest = (lib.importTOML ./Cargo.toml).workspace.package;
        in
        {
          packages = rec {
            default = name;

            name = pkgs.rustPlatform.buildRustPackage rec {
              pname = "name";
              inherit (manifest) version;

              src = ./.;
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
              devenv.root =
                let
                  devenvRoot = builtins.readFile inputs.devenv-root.outPath;
                in
                # If not overridden (/dev/null), --impure is necessary.
                lib.mkIf (devenvRoot != "") devenvRoot;

              name = "Rust with Cargo workspaces";

              packages = with pkgs; [
                cargo-deny
                cargo-edit
                cargo-expand
                cargo-msrv
                cargo-udeps

                codespell
              ];

              languages = {
                nix.enable = true;
                rust.enable = true;
              };

              pre-commit.hooks = {
                clippy.enable = true;
                deadnix.enable = true;
                flake-checker.enable = true;
                nixfmt-rfc-style.enable = true;
                rustfmt.enable = true;
                statix.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
