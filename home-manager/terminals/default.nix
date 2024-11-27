{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.terminals;
in
{
  imports = [
    ./alacritty
    ./kitty
    ./wezterm

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "terminals"
      ]
      {
        name = "default";
        default = "wezterm";
        description = "Default terminal to use.";
      }
      {
        alacritty = "Alacritty";
        kitty = "kitty";
        wezterm = "WezTerm";
      }
    )

    (self.lib.mkCommonModules
      [
        "dotfyls"
        "terminals"
        "terminals"
      ]
      (_: _: {
        desktopFile = lib.mkOption {
          internal = true;
          readOnly = true;
        };
      })
      {
        alacritty.specialArgs.desktopFile.default = "Alacritty.desktop";
        kitty.specialArgs.desktopFile.default = "kitty.desktop";
        wezterm.specialArgs.desktopFile.default = "org.wezfurlong.wezterm.desktop";
      }
    )
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
      ${cfg.selected.desktopFile}

      Alacritty.desktop
      kitty.desktop
      org.wezfurlong.wezterm.desktop

      /execarg_default:org.wezfurlong.wezterm.desktop:start

      -org.kde.yakuake.desktop

      /execarg_default:com.raggesilver.BlackBox.desktop:--
      /execarg_default:contour.desktop:execute
      /execarg_default:deepin-terminal.desktop:-x
      /execarg_default:io.elementary.terminal.desktop:-x
      /execarg_default:org.codeberg.dnkl.foot.desktop:--
      /execarg_default:org.gnome.Terminal.desktop:--
      /execarg_default:kitty.desktop:--
      /execarg_default:mate-terminal.desktop:-x
      /execarg_default:roxterm.desktop:-x
      /execarg_default:terminator.desktop:-x
      /execarg_default:xfce4-terminal.desktop:-x
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
