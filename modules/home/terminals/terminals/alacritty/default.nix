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
      [ "dotfyls" "terminals" "terminals" "alacritty" ]
      [ "programs" "alacritty" ]
    )
  ];

  options.dotfyls.terminals.terminals.alacritty.enable = lib.mkEnableOption "Alacritty";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          decorations = "None";
          inherit (cfg') opacity;
        };
        scrolling.history = cfg'.scrollback;
        font.size = cfg'.fontSize;
        cursor.style = {
          shape = "Beam";
          blinking = "On";
        };
        mouse.hide_when_typing = true;
      };
    };
  };
}
