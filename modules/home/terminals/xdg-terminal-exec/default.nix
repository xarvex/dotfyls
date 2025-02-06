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
    foot = "foot.desktop";
    kitty = "kitty.desktop";
    wezterm = "org.wezfurlong.wezterm.desktop";
  };
in
{
  options.dotfyls.terminals.xdg-terminal-exec = {
    enable = lib.mkEnableOption "xdg-terminal-exec" // {
      default = true;
    };
    package = self.lib.mkStaticPackageOption pkgs.xdg-terminal-exec;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    home.packages = with pkgs; [ xdg-terminal-exec ];

    xdg.configFile."xdg-terminals.list".text = ''
      ${desktopFiles.${cfg'.default}}

      ${builtins.readFile ./xdg-terminals.list}
    '';

    dconf.settings = {
      "org/cinnamon/desktop/applications/terminal".exec = lib.getExe pkgs.xdg-terminal-exec;
      "org/gnome/desktop/applications/terminal".exec = lib.getExe pkgs.xdg-terminal-exec;
    };
  };
}
