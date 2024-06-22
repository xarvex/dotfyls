{ config, lib, pkgs, ... }:

{
  options.custom.programs.wezterm.enable = lib.mkEnableOption "WezTerm" // { default = true; };

  config = lib.mkIf config.custom.programs.wezterm.enable {
    programs.wezterm.enable = true;
    custom.terminal.package = lib.mkDefault pkgs.wezterm;
  };
}
