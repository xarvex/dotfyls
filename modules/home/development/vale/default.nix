{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.vale;
in
{
  options.dotfyls.development.vale.enable = lib.mkEnableOption "Vale" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls = {
      development.tools = with pkgs; [ vale-ls ];
      editors.neovim.lsp.vale_ls = {
        init_options.installVale = false;
        filetypes = [
          "asciidoc"
          "c"
          "cpp"
          "cs"
          "css"
          "go"
          "haskell"
          "html"
          "java"
          "javascript"
          "lua"
          "markdown"
          "org"
          "perl"
          "php"
          "pod"
          "proto"
          "ps1"
          "python"
          "r"
          "rst"
          "ruby"
          "rust"
          "sass"
          "sbt"
          "scala"
          "swift"
          "tex"
          "text"
          "typescript"
          "typescriptreact"
          "xhtml"
          "xml"
        ];
      };
    };

    xdg.configFile = {
      "vale/styles".source = ./styles;
      "vale/.vale.ini".source = ./.vale.ini;
    };
  };
}
