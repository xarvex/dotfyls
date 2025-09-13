{ pkgs, ... }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cargo
    rustc

    cargo-deny
    cargo-edit
    cargo-expand
    cargo-msrv
    cargo-sort
    cargo-udeps

    clippy
    deadnix
    flake-checker
    nixfmt-rfc-style
    pre-commit
    rust-analyzer
    rustfmt
    statix
  ];

  env = {
    RUST_BACKTRACE = 1;
    RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
  };

  shellHook = ''
    pre-commit install
  '';
}
