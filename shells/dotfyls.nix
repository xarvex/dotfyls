{ pkgs, self }:

let
  inherit (self.checks.${pkgs.system}) pre-commit;
in
pkgs.mkShellNoCC {
  nativeBuildInputs =
    pre-commit.enabledPackages
    ++ (with pkgs; [
      nix

      shellcheck
    ]);

  inherit (pre-commit) shellHook;
}
