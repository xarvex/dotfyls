{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.terminals.alacritty;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "terminals"
        "terminals"
        "alacritty"
      ]
      [
        "programs"
        "alacritty"
      ]
    )
  ];

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.alacritty = {
      enable = true;

      settings = {
        font = {
          normal.family = "monospace";
          size = cfg'.fontSize;
        };
        window = {
          dimensions = {
            columns = 80;
            lines = 24;
          };
          opacity = 0.85;
        };
        cursor.style.blinking = "Never";
      };
    };
  };
}
