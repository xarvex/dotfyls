{ config, lib, pkgs, ... }:

{
  options.dotfyls.terminals.wezterm.enable = lib.mkEnableOption "WezTerm";

  config = lib.mkIf config.dotfyls.terminals.wezterm.enable {
    programs.wezterm.enable = true;

    dotfyls.terminal = rec {
      start.wezterm = lib.getExe pkgs.wezterm;
      exec.wezterm = "${start.wezterm} start";
    };
  };
}
