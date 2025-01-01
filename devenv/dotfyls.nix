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

  name = "dotfyls";

  packages = with pkgs; [
    codespell
    vale-ls
  ];

  languages = {
    nix.enable = true;
    shell.enable = true;
  };

  pre-commit.hooks = {
    deadnix.enable = true;
    flake-checker.enable = true;
    nixfmt-rfc-style.enable = true;
    statix.enable = true;
    stylua.enable = true;
  };
}
