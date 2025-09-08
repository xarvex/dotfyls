{ lib, pkgs }:

pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [
    deadnix
    flake-checker
    nixfmt-rfc-style
    pre-commit
    selene
    shellcheck
    statix
    stylua
  ];

  env.FLAKE_CHECKER_NO_TELEMETRY = lib.boolToString true;

  shellHook = ''
    pre-commit install
  '';
}
