{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.terminals.terminals.alacritty;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "terminals" "terminals" "alacritty" ]
      [ "programs" "alacritty" ])
  ];

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = pkgs.lib.importTOML ./alacritty.toml
        // {
        font = {
          normal.family = config.dotfyls.fonts.monospace.name;
          size = config.dotfyls.terminals.fontSize;
        };
      };
    };
  };
}
