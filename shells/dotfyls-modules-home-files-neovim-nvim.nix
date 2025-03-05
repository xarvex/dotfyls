{ dotfyls, pkgs }:

dotfyls.overrideAttrs (o: {
  nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ (with pkgs; [ luajit ]);
  buildInputs = with pkgs; [
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
  ];

  enterShell =
    (o.enterShell or "")
    + ''
      NVIM_APPNAME="dotfyls/devshell/nvim/$(git log -1 --format=%h @{push})"
      export NVIM_APPNAME
      mkdir -p "''${XDG_CONFIG_HOME:-''${HOME}/.config}/dotfyls/devshell/nvim"
      ln -fsT "''${PWD}" "''${XDG_CONFIG_HOME:-''${HOME}/.config}/''${NVIM_APPNAME}"
    '';
})
