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
      [ "dotfyls" "terminals" "terminals" "wezterm" ]
      [ "programs" "wezterm" ]
    )
  ];

  options.dotfyls.terminals.terminals.wezterm.enable = lib.mkEnableOption "WezTerm";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/wezterm/plugins" = {
      mode = "0700";
      cache = true;
    };

    programs.wezterm.enable = true;

    xdg.configFile = {
      wezterm = {
        recursive = true;
        source = lib.fileset.toSource {
          root = ./wezterm;
          fileset = lib.fileset.fileFilter (file: lib.hasSuffix ".lua" file.name) ./wezterm;
        };
      };
      "wezterm/wezterm.lua".enable = false;
    };
  };
}
