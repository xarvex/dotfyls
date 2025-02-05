{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.typst;
in
{
  options.dotfyls.development.languages.typst.enable = lib.mkEnableOption "Typst" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development = {
        tools = with pkgs; [
          tinymist
          typstyle
        ];
        languages.servers.tinymist.settings = {
          exportPdf = "onDocumentHasTitle";
          formatterMode = "typstyle";
          completion.triggerOnSnippetPlaceholders = true;
          preview = {
            scrollSync = "onSelectionChange";
            cursorIndicator = true;
          };
        };
      };

      file.".cache/typst".cache = true;
    };
  };
}
