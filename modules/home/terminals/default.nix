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
  };
}
