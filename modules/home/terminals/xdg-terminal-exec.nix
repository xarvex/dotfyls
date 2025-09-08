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
  options.dotfyls.terminals.xdg-terminal-exec.enable = lib.mkEnableOption "xdg-terminal-exec" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    xdg = {
      terminal-exec = {
        enable = true;

        settings.default = [
          desktopFiles.${cfg'.default}
        ]
        ++ builtins.attrValues desktopFiles;
      };

      systemDirs.data = [
        "${
          pkgs.runCommandLocal "xdg-terminals-list" { nativeBuildInputs = with pkgs; [ coreutils ]; } ''
            install -D \
              ${config.xdg.terminal-exec.package.src}/xdg-terminals.list \
              $out/share/xdg-terminal-exec/xdg-terminals.list
          ''
        }/share"
      ];
    };

    dconf.settings = {
      "org/cinnamon/desktop/applications/terminal".exec = self.lib.getCfgExe config.xdg.terminal-exec;
      "org/gnome/desktop/applications/terminal".exec = self.lib.getCfgExe config.xdg.terminal-exec;
    };

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, Return, exec, ${self.lib.getCfgExe config.xdg.terminal-exec}"
    ];
  };
}
