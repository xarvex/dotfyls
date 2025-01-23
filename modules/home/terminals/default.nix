{ lib, self, ... }:

{
  imports = [
    ./terminals
    ./xdg-terminal-exec

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
}
