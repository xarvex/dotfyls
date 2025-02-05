{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.vala;
in
{
  options.dotfyls.development.languages.vala.enable = lib.mkEnableOption "Vala" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development = {
      tools = with pkgs; [
        uncrustify
        vala-language-server
        vala-lint
        vale-ls
      ];
      languages.servers.vala_ls = { };
    };
  };
}
