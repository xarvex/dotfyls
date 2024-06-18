{ config, lib, pkgs, ... }:

{
  options.custom.program.wezterm.enable = lib.mkEnableOption "WezTerm" // { default = true; };

  config = lib.mkIf config.custom.program.wezterm.enable {
    programs.wezterm.enable = true;
    custom.terminal.package = lib.mkDefault pkgs.wezterm;

    custom.persist.directories = [ ".config/wezterm" ];
  };
}
