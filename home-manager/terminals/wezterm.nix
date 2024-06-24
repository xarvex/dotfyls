{ config, lib, pkgs, ... }:

{
  options.custom.terminals.wezterm.enable = lib.mkEnableOption "Enable WezTerm (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.terminals.wezterm.enable {
    programs.wezterm.enable = true;

    custom.terminal = {
      default = lib.mkDefault "wezterm";
      start.wezterm = lib.getExe pkgs.wezterm;
      exec.wezterm = "${lib.getExe pkgs.wezterm} start";
    };
  };
}
