{
  config,
  lib,
  self,
  ...
}:

# enabledLanguages = lib.filterAttrs (name: language: !language.enable) cfg.languages;
let
  cfg = config.dotfyls.development;
in
{
  imports = [
    ./go.nix
    ./javascript.nix
    ./lua.nix
    ./python.nix
    ./rust.nix

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "development"
        "direnv"
      ]
      [
        "programs"
        "direnv"
      ]
    )

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

  options.dotfyls.development = {
    enable = lib.mkEnableOption "development" // {
      default = config.dotfyls.desktops.enable;
    };
    direnv.enable = lib.mkEnableOption "direnv" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { }

      (lib.mkIf cfg.direnv.enable {
        dotfyls.files = {
          persistDirectories = [ ".local/share/direnv" ];
          cacheDirectories = [ ".cache/direnv/layouts" ];
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          wherenver.enable = true;

          config = {
            strict_env = true;
            hide_env_diff = true;
          };
          stdlib = ''
            declare -A direnv_layout_dirs
            direnv_layout_dir() {
                printf '%s\n' "''${direnv_layout_dirs[''${PWD}]:=${config.xdg.cacheHome}/direnv/layouts/$(sha1sum - <<<"''${PWD}" | head -c40)''${PWD//[^a-zA-Z0-9]/-}}"
            }
          '';
        };
      })
    ]
  );
}
