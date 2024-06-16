{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.mkIf config.hm.custom.program.zsh.enable {
    programs.zsh.enable = true;
    usr.shell = pkgs.zsh;
  })
]
