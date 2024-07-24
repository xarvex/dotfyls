{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.terminals.terminals.wezterm;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "terminals" "terminals" "wezterm" "package" ]
      [ "programs" "wezterm" "package" ])
  ];

  config = lib.mkIf cfg.enable {
    dotfyls.terminals.terminals.wezterm = {
      exec = lib.mkDefault (pkgs.lib.dotfyls.mkCommand ''exec ${lib.getExe cfg.start} start "$@"'');
    };

    programs.wezterm.enable = true;
  };
}
