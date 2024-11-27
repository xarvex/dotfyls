{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.terminals.wezterm;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "terminals"
        "terminals"
        "wezterm"
      ]
      [
        "programs"
        "wezterm"
      ]
    )
  ];

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.directories = [ ".local/share/wezterm" ];

    programs.wezterm.enable = true;
  };
}
