{ config, lib, pkgs, ... }:

lib.mkMerge [
  (lib.mkIf config.hm.custom.programs.zsh.enable {
    programs.zsh.enable = true;
    usr.shell = pkgs.zsh;
  })
]
