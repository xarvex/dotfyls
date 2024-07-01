{ config, lib, pkgs, ... }:

{
  options.dotfyls.terminals.wezterm.enable = lib.mkEnableOption "WezTerm" // { default = true; };

  config = lib.mkIf config.dotfyls.terminals.wezterm.enable {
    programs.wezterm.enable = true;

    dotfyls.terminal = rec {
      default = lib.mkDefault "wezterm";
      start.wezterm = lib.getExe pkgs.wezterm;
      exec.wezterm = "${start.wezterm} start";
    };
  };
}
