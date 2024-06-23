{ config, lib, pkgs, ... }:

{
  options.custom.programs.wezterm.enable = lib.mkEnableOption "WezTerm" // { default = true; };

  config = lib.mkIf config.custom.programs.wezterm.enable {
    programs.wezterm.enable = true;
    custom.terminal = {
      default = lib.mkDefault "wezterm";
      start.wezterm = lib.getExe pkgs.wezterm;
      exec.wezterm = "${lib.getExe pkgs.wezterm} start";
    };
  };
}
