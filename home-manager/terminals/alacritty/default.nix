{ config, lib, pkgs, ... }:

let
  cfg = config.dotfyls.terminals.terminals.alacritty;
in
{
  imports = [
    (lib.mkAliasOptionModule
      [ "dotfyls" "terminals" "terminals" "alacritty" "package" ]
      [ "programs" "alacritty" "package" ])
  ];

  config = lib.mkIf cfg.enable {
    dotfyls.terminals.terminals.alacritty = {
      exec = lib.mkDefault (pkgs.lib.dotfyls.mkCommand ''exec ${lib.getExe cfg.start} -e "$@"'');
    };

    programs.alacritty = {
      enable = true;
      settings = pkgs.lib.importTOML ./alacritty.toml // {
        font = {
          normal.family = config.dotfyls.fonts.monospace.name;
          size = config.dotfyls.terminals.fontSize;
        };
      };
    };
  };
}
