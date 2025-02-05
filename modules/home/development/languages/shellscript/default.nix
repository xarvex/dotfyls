# TODO: Complete checklist:
# [x] LSP
# [x] Linter
# [x] Formatter
# [ ] Debugger
# [ ] Tester
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.shellscript;
in
{
  options.dotfyls.development.languages.shellscript = {
    enable = lib.mkEnableOption "shellscript" // {
      default = cfg'.defaultEnable;
    };
    fishSupport = lib.mkEnableOption "Fish" // {
      default = cfg'.defaultEnable;
    };
    zshSupport = lib.mkEnableOption "Zsh" // {
      default = cfg'.defaultEnable;
    };
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development.tools =
      (with pkgs; [
        bash-language-server
        shellcheck
        shfmt
      ])
      ++ lib.optionals cfg.fishSupport (
        with pkgs;
        [
          fish # NOTE: Provides linter and formatter.
          fish-lsp
        ]
      )
      ++ lib.optional cfg.zshSupport pkgs.zsh; # NOTE: Provides linter.
  };
}
