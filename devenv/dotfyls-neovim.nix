{
  dotfyls,
  lib,
  pkgs,
}:

lib.recursiveUpdate dotfyls {
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
}
