{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.terminals;
in
{
  imports = [
    ./alacritty
    ./kitty.nix
    ./wezterm.nix

    (self.lib.mkSelectorModule [ "dotfyls" "terminals" ]
      {
        name = "default";
        default = "wezterm";
        description = "Default terminal to use.";
      }
      {
        alacritty = "Alacritty";
        kitty = "kitty";
        wezterm = "WezTerm";
      })

    (self.lib.mkCommonModules [ "dotfyls" "terminals" "terminals" ]
      (terminal: tCfg: {
        start = self.lib.mkCommandOption "start ${terminal.name}"
          // lib.optionalAttrs tCfg.enable { default = self.lib.getCfgPkg tCfg; };
        exec = self.lib.mkCommandOption "start ${terminal.name} executing command"
          // lib.optionalAttrs tCfg.enable { default = self.lib.getCfgPkg tCfg; };
      })
      {
        alacritty = {
          name = "Alacritty";
          specialArgs = {
            exec.default = pkgs.dotfyls.mkCommand
              ''exec ${lib.getExe cfg.terminals.alacritty.start} -e "$@"'';
          };
        };
        kitty = {
          name = "kitty";
        };
        wezterm = {
          name = "WezTerm";
          specialArgs = {
            exec.default = pkgs.dotfyls.mkCommand
              ''exec ${lib.getExe cfg.terminals.wezterm.start} start "$@"'';
          };
        };
      })
  ];

  options.dotfyls.terminals = {
    enable = lib.mkEnableOption "terminals" // { default = true; };
    xdg-terminal-exec = {
      enable = lib.mkEnableOption "xdg-terminal-exec" // { default = true; };
      package = self.lib.mkCommandOption "use as xdg-terminal-exec"
        // lib.optionalAttrs (cfg.enable && cfg.xdg-terminal-exec.enable) {
        default = (pkgs.dotfyls.mkCommand' "xdg-terminal-exec" ''
          if [ "$#" = "0" ]; then
            exec ${lib.getExe cfg.selected.start}
          else
            if [ "$1" = "-e" ]; then
              shift
            fi
            exec ${lib.getExe cfg.selected.exec} "$@"
          fi
        '');
      };
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

    dconf.settings = {
      "org/cinnamon/desktop/applications/terminal" = { exec = self.lib.getCfgExe cfg.xdg-terminal-exec; };
      "org/gnome/desktop/applications/terminal" = { exec = self.lib.getCfgExe cfg.xdg-terminal-exec; };
    };
  };
}
