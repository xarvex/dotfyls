{
  pkgs,
  poetry2nix,
  self,
  ...
}:

let
  inherit (self.checks.${pkgs.system}) pre-commit;
in
pkgs.mkShellNoCC {
  nativeBuildInputs = pre-commit.enabledPackages ++ [
    (poetry2nix.mkPoetryEnv { projectDir = ./.; })
  ];

  inherit (pre-commit) shellHook;
}
