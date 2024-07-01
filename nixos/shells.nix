{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.mkIf config.hm.dotfyls.shells.zsh.enable {
    programs.zsh.enable = true;

    usr.shell = pkgs.zsh;
  })
]
