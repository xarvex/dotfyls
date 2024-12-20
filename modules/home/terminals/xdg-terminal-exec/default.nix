{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.xdg-terminal-exec;

  desktopFiles = {
    alacritty = "Alacritty.desktop";
    kitty = "kitty.desktop";
    wezterm = "org.wezfurlong.wezterm.desktop";
  };
in
{
  options.dotfyls.terminals.xdg-terminal-exec = {
    enable = lib.mkEnableOption "xdg-terminal-exec" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "xdg-terminal-exec" { };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = [ (self.lib.getCfgPkg cfg) ];

    xdg.configFile."xdg-terminals.list".text = ''
      ${desktopFiles.${cfg'.default}}

      ${builtins.readFile ./xdg-terminals.list}
    '';

    dconf.settings = {
      "org/cinnamon/desktop/applications/terminal".exec = self.lib.getCfgExe cfg;
      "org/gnome/desktop/applications/terminal".exec = self.lib.getCfgExe cfg;
    };
  };
}
