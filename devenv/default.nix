{
  inputs,
  lib,
  pkgs,
}:

rec {
  default = dotfyls;

  dotfyls = {
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
  };

  dotfyls-neovim = lib.recursiveUpdate dotfyls {
    name = "${dotfyls.name} - Neovim";

    packages =
      dotfyls.packages
      ++ (with pkgs; [
        chafa
        delta
        fd
        fzf
        gcc
        git
        gnumake
        neovim
        nodejs_22
        ripgrep
      ]);

    enterShell = ''
      NVIM_APPNAME="dotfyls/devshell/nvim/$(git log -1 --format=%h @{push})"
      export NVIM_APPNAME
      mkdir -p "''${XDG_CONFIG_HOME:-''${HOME}/.config}/dotfyls/devshell/nvim"
      ln -fsT "''${PWD}" "''${XDG_CONFIG_HOME:-''${HOME}/.config}/''${NVIM_APPNAME}"
    '';

    languages.lua = {
      enable = true;
      package = pkgs.luajit;
    };
  };
}
