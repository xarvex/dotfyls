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
      development.tools = with pkgs; [
        tinymist
        typstyle
      ];
      editors.neovim.lsp.tinymist.settings = {
        outputPath = "${config.xdg.cacheHome}/tinymist/$root/$dir/$name";
        exportPdf = "onDocumentHasTitle";
        lint = {
          enabled = true;
          when = "onType";
        };
        formatterMode = "typstyle";
        completion.triggerOnSnippetPlaceholders = true;
        preview = {
          scrollSync = "onSelectionChange";
          cursorIndicator = true;
        };
      };

      file = {
        ".cache/typst".cache = true;
        ".cache/tinymist".cache = true;
      };
    };
  };
}
