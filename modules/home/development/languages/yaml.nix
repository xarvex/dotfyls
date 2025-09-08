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
    dotfyls = {
      development.tools = with pkgs; [
        yaml-language-server
        yamllint
      ];
      editors.neovim.lsp.yamlls.settings = {
        redhat.telemetry.enabled = false;
        yaml = { };
      };
    };

    xdg.configFile."yamllint/config.yaml".source = pkgs.runCommand "yamllint-config" {
      nativeBuildInputs = with pkgs; [ yj ];

      json = builtins.toJSON {
        extends = "default";
        rules.line-length = {
          max = 120;
          level = "warning";
        };
      };
      passAsFile = [ "json" ];
    } "yj -jy <$jsonPath >$out";
  };
}
