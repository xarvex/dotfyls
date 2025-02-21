{
  pkgs,
  self,
  ...
}:

let
  inherit (self.checks.${pkgs.system}) pre-commit;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cargo
    rustc
  ];
  buildInputs =
    pre-commit.enabledPackages
    ++ (with pkgs; [
      clippy
      rust-analyzer

      cargo-deny
      cargo-edit
      cargo-expand
      cargo-msrv
      cargo-udeps
    ]);

  RUST_BACKTRACE = 1;
  RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

  inherit (pre-commit) shellHook;
}
