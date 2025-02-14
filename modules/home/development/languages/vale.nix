{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.vale;
in
{
  options.dotfyls.development.languages.vale = lib.mkEnableOption "Vale" // {
    default = true;
  };

  config = lib.mkIf (cfg''.enable && cfg) {
    dotfyls.development = {
      tools = with pkgs; [ vale-ls ];
      languages.servers.vale_ls.init_options.installVale = false;
    };

    xdg.configFile = {
      "vale/styles" = {
        recursive = true;
        source = ./styles;
      };
      "vale/.vale.ini".text = ''
        StylesPath = styles
        Vocab = dotfyls
        MinAlertLevel = suggestion

        [formats]
        rs = md

        [*]
        BasedOnStyles = Vale
        Vale.Spelling = suggestion
        Vale.Terms = suggestion
        Vale.Avoid = suggestion
        Vale.Repetition = suggestion
      '';
    };
  };
}
