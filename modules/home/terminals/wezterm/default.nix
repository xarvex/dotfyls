{ config, lib, ... }:

let
  cfg' = config.dotfyls.terminals;
  cfg = cfg'.wezterm;
in
{
  options.dotfyls.terminals.wezterm.enable = lib.mkEnableOption "WezTerm";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".local/share/wezterm/plugins" = {
      mode = "0700";
      cache = true;
    };

    programs.wezterm.enable = true;

    xdg.configFile = {
      "wezterm/wezterm.lua".source = ./wezterm.lua;
      "wezterm/nix.lua".text = ''
        return {
            ---@param config table
            apply_to_config = function(config)
                config.default_prog = { "${config.home.sessionVariables.SHELL}" }
                config.font_size = ${toString cfg'.fontSize}
                config.scrollback_lines = ${toString cfg'.scrollback}
                config.window_background_opacity = ${toString cfg'.opacity}
                if config.window_frame ~= nil then config.window_frame = {} end
                config.window_frame.font_size = ${toString cfg'.fontSize}
            end,
        }
      '';
    };
  };
}
