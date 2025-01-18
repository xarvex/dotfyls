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
    ./programs
    ./shells

    (self.lib.mkSelectorModule [ "dotfyls" "shells" ] {
      name = "default";
      default = "fish";
      example = "zsh";
      description = "Default shell to use.";
    })
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
      example = lib.literalExpression ''
        ''${lib.getExe pkgs.fastfetch}
      '';
      description = ''
        Commands that should be run to greet the user.
        Note that these commands will run for any shell.
      '';
    };
  };

  config = {
    home = {
      sessionVariables = rec {
        DOTFYLS_SHELL = SHELL;
        SHELL =
          let
            sCfg = cfg.shells.${cfg.default};
          in
          lib.mkIf (sCfg ? package) (self.lib.getCfgExe sCfg);
      };

      shellAliases = {
        ".." = "cd ..";

        watchfile = lib.mkDefault "watch -cn1 -x cat";
        ccat = "command cat";
      };
    };
  };
}
