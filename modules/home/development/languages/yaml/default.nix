{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.yaml;
in
{
  options.dotfyls.development.languages.yaml.enable = lib.mkEnableOption "YAML" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development = {
      tools = with pkgs; [
        yaml-language-server
        yamllint
      ];
      languages.servers.yamlls.settings = {
        redhat.telemetry.enabled = false;
        yaml = { };
      };
    };
  };
}
