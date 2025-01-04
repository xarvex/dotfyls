{
  inputs,
  lib,
  pkgs,
}:

{
  devenv.root =
    let
      devenvRoot = builtins.readFile inputs.devenv-root.outPath;
    in
    # If not overridden (/dev/null), --impure is necessary.
    lib.mkIf (devenvRoot != "") devenvRoot;

  name = "project-name";

  packages = with pkgs; [
    cargo-deny
    cargo-edit
    cargo-expand
    cargo-msrv
    cargo-udeps

    codespell
    vale-ls

    sqlx-cli
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

  services.postgres.enable = true;
}
