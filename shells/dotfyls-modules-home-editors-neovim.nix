{ dotfyls, pkgs }:

dotfyls.overrideAttrs (o: {
  nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ (with pkgs; [ luajit ]);
  buildInputs =
    (o.buildInputs or [ ])
    ++ (with pkgs; [
      chafa
      fd
      fzf
      gcc
      ghostscript_headless
      git
      gnumake
      imagemagick
      neovim
      nodePackages.nodejs
      ripgrep
    ]);

  shellHook =
    (dotfyls.shellHook or "")
    # bash
    + ''
      NVIM_APPNAME=dotfyls/devshell/nvim/$(git log -1 --format=%h @{push})
      export NVIM_APPNAME
      mkdir -p "''${XDG_CONFIG_HOME:-''${HOME}/.config}"/dotfyls/devshell/nvim
      ln -fsT "''${PWD}" "''${XDG_CONFIG_HOME:-''${HOME}/.config}"/"''${NVIM_APPNAME}"
    '';
})
