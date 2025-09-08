{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.terminals;
in
{
  imports = [
    ./wezterm

    ./alacritty.nix
    ./foot.nix
    ./kitty.nix
    ./xdg-terminal-exec.nix
  ];

  options.dotfyls.terminals = {
    enable = lib.mkEnableOption "terminals" // {
      default = true;
    };
    default = lib.mkOption {
      type = lib.types.enum [
        "alacritty"
        "foot"
        "kitty"
        "wezterm"
      ];
      default = "kitty";
      example = "alacritty";
      description = "Default terminal to use.";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 16;
      example = 12;
      description = "Font size to use for terminals.";
    };
    opacity = lib.mkOption {
      type = lib.types.numbers.between 0 1;
      default = 0.9;
      example = 0.85;
      description = "Opacity to use for terminals.";
    };
    scrollback = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      example = 100000;
      description = "Number of scrollback lines to use for terminals.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.terminals = self.lib.enableSelected cfg.default [
      "alacritty"
      "foot"
      "kitty"
      "wezterm"
    ];
  };
}
