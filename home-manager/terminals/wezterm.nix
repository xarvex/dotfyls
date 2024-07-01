{ config, lib, pkgs, ... }:

{
  options.custom.terminals.wezterm.enable = lib.mkEnableOption "WezTerm" // { default = true; };

  config = lib.mkIf config.custom.terminals.wezterm.enable {
    programs.wezterm.enable = true;

    custom.terminal = rec {
      default = lib.mkDefault "wezterm";
      start.wezterm = lib.getExe pkgs.wezterm;
      exec.wezterm = "${start.wezterm} start";
    };
  };
}
