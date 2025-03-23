{ pkgs }:

pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [
    nix

    deadnix
    flake-checker
    nixfmt-rfc-style
    pre-commit
    selene
    shellcheck
    statix
    stylua
  ];

  env.FLAKE_CHECKER_NO_TELEMETRY = "true";

  shellHook = ''
    pre-commit install
  '';
}
