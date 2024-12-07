{
  config,
  inputs,
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
    inputs.dotfyls-wezterm.homeManagerModules.wezterm

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

  options.dotfyls.terminals.terminals.wezterm.enable = lib.mkEnableOption "WezTerm";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/wezterm/plugins" = {
      mode = "0700";
      cache = true;
    };

    programs.wezterm.enable = true;
  };
}
