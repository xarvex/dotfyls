{ config, lib, pkgs, ... }:

{
  options.dotfyls.terminals.alacritty.enable = lib.mkEnableOption "Alacritty";

  config = lib.mkIf config.dotfyls.terminals.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = pkgs.lib.importTOML ./alacritty.toml;
    };

    dotfyls.terminals = rec {
      start.alacritty = lib.getExe pkgs.alacritty;
      exec.alacritty = "${start.alacritty} -e";
    };
  };
}
