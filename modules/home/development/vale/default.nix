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
    dotfyls.development = {
      tools = with pkgs; [ vale-ls ];
      languages.servers.vale_ls.init_options.installVale = false;
    };

    xdg.configFile = {
      "vale/styles" = {
        recursive = true;
        source = ./styles;
      };
      "vale/.vale.ini".source = ./.vale.ini;
    };
  };
}
