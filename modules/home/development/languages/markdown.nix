# TODO: Complete checklist:
# [ ] LSP
# [/] Linter
# [ ] Formatter
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.markdown;
in
{
  options.dotfyls.development.languages.markdown.enable = lib.mkEnableOption "Markdown" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development.tools = with pkgs; [
      markdownlint-cli2
      mdformat
    ];
  };
}
