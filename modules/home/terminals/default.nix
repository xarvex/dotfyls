{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.terminals;

  desktopFiles = {
    alacritty = "Alacritty.desktop";
    kitty = "kitty.desktop";
    wezterm = "org.wezfurlong.wezterm.desktop";
  };
in
{
  imports = [
    ./alacritty
    ./kitty
    ./wezterm

    (self.lib.mkSelectorModule [ "dotfyls" "terminals" ] {
      name = "default";
      default = "kitty";
      example = "alacritty";
      description = "Default terminal to use.";
    })
  ];

  options.dotfyls.terminals = {
    enable = lib.mkEnableOption "terminals" // {
      default = true;
    };
    xdg-terminal-exec = {
      enable = lib.mkEnableOption "xdg-terminal-exec" // {
        default = true;
      };
      package = lib.mkPackageOption pkgs "xdg-terminal-exec" { };
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
      example = 12;
      description = "Font size to use for terminals.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.xdg-terminal-exec.enable) {
    home.packages = [ (self.lib.getCfgPkg cfg.xdg-terminal-exec) ];

    xdg.configFile."xdg-terminals.list".text = ''
      ${desktopFiles.${cfg.default}}

      ${builtins.readFile ./xdg-terminals.list}
    '';

    dconf.settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = self.lib.getCfgExe cfg.xdg-terminal-exec;
      };
      "org/gnome/desktop/applications/terminal" = {
        exec = self.lib.getCfgExe cfg.xdg-terminal-exec;
      };
    };
  };
}
