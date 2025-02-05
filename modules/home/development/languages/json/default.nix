# TODO: Complete checklist:
# [x] LSP
# [ ] Linter
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
  cfg = cfg'.json;
in
{
  options.dotfyls.development.languages.json.enable = lib.mkEnableOption "JSON" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development = {
      tools = with pkgs; [ vscode-langservers-extracted ];

      # NOTE: Default, but must still specify as the value is flipped to false
      # when a configuration is given.
      # See: https://github.com/b0o/SchemaStore.nvim/issues/8
      languages.servers.jsonls.settings.json.validate.enable = true;
    };
  };
}
