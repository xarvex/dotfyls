# TODO: Complete checklist:
# [/] LSP
# [x] Linter
# [x] Formatter
# [ ] Debugger
# [ ] Tester
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.typescript;

  jCfg = cfg'.javascript;
in
{
  options.dotfyls.development.languages.typescript.enable = lib.mkEnableOption "TypeScript" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development.languages = {
      javascript.enable = true;
      servers.ts_ls = {
        init_options.plugins = lib.optional jCfg.frameworks.astro {
          name = "@astrojs/ts-plugin";
          location = "${pkgs.astro-language-server}/lib/astro-language-server/packages/ts-plugin";
          languages = [
            "astro"
            "javascript"
            "javascript.jsx"
            "javascriptreact"
            "typescript"
            "typescript.tsx"
            "typescriptreact"
          ];
        };
        filetypes = [
          "typescript"
          "typescript.tsx"
          "typescriptreact"
        ] ++ lib.optional jCfg.frameworks.astro "astro";
      };
    };
  };
}
