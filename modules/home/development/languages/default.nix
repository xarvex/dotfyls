{ lib, self, ... }:

{
  imports = [
    ./go
    ./javascript
    ./lua
    ./python
    ./rust

    (self.lib.mkCommonModules
      [
        "dotfyls"
        "development"
        "languages"
      ]
      (language: _: {
        enable = lib.mkEnableOption language.name // {
          default = true;
        };
        templates = lib.mkOption {
          type = with lib.types; listOf str;
          description = "Templates available for ${language.name}.";
        };
      })
      {
        c = {
          name = "C";
          specialArgs.templates.default = [ "c" ];
        };
        go = {
          name = "Go";
          specialArgs.templates.default = [
            "golang"
            "go"
          ];
        };
        javascript = {
          name = "JavaScript";
          specialArgs.templates.default = [
            "js"
            "javascript"

            "ts"
            "typescript"
          ];
        };
        lua = {
          name = "Lua";
          specialArgs.templates.default = [ "lua" ];
        };
        python = {
          name = "Python";
          specialArgs.templates.default = [
            "py"
            "python"
          ];
        };
        rust = {
          name = "Rust";
          specialArgs.templates.default = [
            "rs"
            "rust"

            "rs-pg"
            "rs-postgres"
            "rust-pg"
            "rust-postgres"
          ];
        };
      }
    )
  ];
}
