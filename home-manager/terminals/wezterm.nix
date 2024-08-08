{ config, lib, self, ... }:

let
  cfg = config.dotfyls.terminals.terminals.wezterm;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "terminals" "terminals" "wezterm" ]
      [ "programs" "wezterm" ])
  ];

  config = lib.mkIf cfg.enable {
    programs.wezterm.enable = true;
  };
}
