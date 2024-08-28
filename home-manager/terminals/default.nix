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
          // lib.optionalAttrs tCfg.enable { default = tCfg.package; };
        exec = self.lib.mkCommandOption "start ${terminal.name} executing command"
          // lib.optionalAttrs tCfg.enable { default = tCfg.package; };
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
    xdgExec = self.lib.mkCommandOption "replace xdg-terminal-exec"
      // lib.optionalAttrs cfg.selected.enable {
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

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
      example = 12;
      description = "Font size to use for terminals.";
    };
  };

  config = {
    home.packages = [ cfg.xdgExec ];

    dconf.settings = {
      "org/cinnamon/desktop/applications/terminal" = { exec = lib.getExe cfg.xdgExec; };
      "org/gnome/desktop/applications/terminal" = { exec = lib.getExe cfg.xdgExec; };
    };
  };
}
