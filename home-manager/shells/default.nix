{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.shells;
in
{
  imports = [
    ./bash
    ./fish
    ./zsh

    (self.lib.mkSelectorModule
      [
        "dotfyls"
        "shells"
      ]
      {
        name = "default";
        default = "fish";
        description = "Default shell to use.";
      }
      {
        bash = "Bash";
        fish = "Fish";
        zsh = "Zsh";
      }
    )
  ];

  options.dotfyls.shells = {
    historySize = lib.mkOption {
      type = lib.types.int;
      default = 256000;
      example = 128000;
      description = "Number of history lines.";
    };

    greet = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Commands that should be run to greet the user.
        Note that these commands will run for any shell.
      '';
    };
  };

  config = {
    dotfyls.shells.shells.bash.enable = lib.mkDefault true;

    home = {
      sessionVariables.SHELL = lib.mkIf (cfg.selected ? package) (self.lib.getCfgExe cfg.selected);

      shellAliases = {
        ".." = "cd ..";

        watchfile = lib.mkDefault "watch -cn1 -x cat";
        ccat = "command cat";
      };
    };
  };
}
