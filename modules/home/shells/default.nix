{
  config,
  lib,
  self,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.shells;
in
{
  imports = [
    ./bash
    ./fish
    ./tools
    ./zsh
  ];

  options.dotfyls.shells = {
    default = lib.mkOption {
      type = lib.types.enum [
        "bash"
        "fish"
        "zsh"
      ];
      default = "fish";
      example = "zsh";
      description = "Default shell to use.";
    };
    historySize = lib.mkOption {
      type = lib.types.int;
      default = 256000;
      example = 128000;
      description = "Number of history lines.";
    };
    greet = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = lib.literalExpression "\${lib.getExe pkgs.fastfetch}";
      description = ''
        Commands that should be run to greet the user.
        Note that these commands will run for any shell.
      '';
    };
  };

  config = {
    dotfyls.shells =
      self.lib.enableSelected cfg.default [
        "bash"
        "fish"
        "zsh"
      ]
      // {
        bash.enable = lib.mkDefault true;
      };

    home = {
      sessionVariables.SHELL = "${
        if osConfig == null then
          "/etc/profiles/per-user/${config.home.username}"
        else
          "/run/current-system/sw"
      }/bin/${cfg.default}";

      shellAliases = {
        ".." = "cd ..";

        watchfile = lib.mkDefault "watch -cn1 -x cat";
        ccat = "command cat";
      };
    };
  };
}
