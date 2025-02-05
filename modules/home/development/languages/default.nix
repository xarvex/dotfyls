# NOTE: Motivation for including all these tools in my home is that they can
# still be overridden via PATH per-project. I have these tools to accelerate
# and give ease towards working on something quickly.
# Also, quite simply, not all of these need to be per-project.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages;

  jsonFormat = pkgs.formats.json { };
in
{
  imports = [
    ./c
    ./css
    ./go
    ./html
    ./java
    ./javascript
    ./json
    ./kotlin
    ./lua
    ./markdown
    ./nix
    ./python
    ./rust
    ./shellscript
    ./slint
    ./sql
    ./toml
    ./typescript
    ./typst
    ./vala
    ./yaml
    ./zig
  ];

  options.dotfyls.development.languages = {
    defaultEnable = lib.mkEnableOption "all languages by default" // {
      default = true;
    };

    codespell = lib.mkEnableOption "codespell" // {
      default = true;
    };
    vale = lib.mkEnableOption "Vale" // {
      default = true;
    };
    servers = lib.mkOption {
      type = lib.types.attrsOf jsonFormat.type;
      default = { };
      description = "Attrset of language servers and their configuration.";
    };
  };

  config = lib.mkIf cfg'.enable {
    dotfyls.development = {
      tools = lib.optional cfg.codespell pkgs.codespell ++ lib.optional cfg.vale pkgs.vale-ls;
      languages.servers.vale_ls.init_options.installVale = false;
    };

    xdg.configFile = lib.mkMerge [
      (lib.mapAttrs' (
        server: configuration:
        lib.nameValuePair "dotfyls/lsp/${server}.json" {
          source = jsonFormat.generate "${server}-configuration" configuration;
        }
      ) cfg.servers)
      {
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
      }
    ];
  };
}
