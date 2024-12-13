system:
{ config, lib, ... }:

let
  cfg = config.dotfyls.file;
in
{
  options.dotfyls.file = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        let
          config' = config;
        in
        { config, name, ... }:
        {
          options = {
            dir = lib.mkEnableOption "treating the file as a directory" // {
              default = true;
            };
            mode = lib.mkOption {
              type = lib.types.str;
              default = if config.dir then "0755" else "0644";
              defaultText = lib.literalExpression ''
                if config.dir then "0755" else "0644"
              '';
              example = lib.literalExpression ''
                if config.dir then "0700" else "0600"
              '';
              description = "Mode of the file.";
            };
            user = lib.mkOption rec {
              type = lib.types.str;
              default = if system then "root" else config'.home.username;
              defaultText = if system then default else (lib.literalExpression "config.home.username");
              example = defaultText;
              description = "User of the file.";
            };
            group = lib.mkOption rec {
              type = lib.types.str;
              default = if system || config.user != config'.home.username then config.user else "users";
              defaultText = lib.literalExpression (
                if system then
                  "cfg.user"
                else
                  ''
                    if cfg.user == config.home.username then users else cfg.user
                  ''
              );
              example = defaultText;
              description = "Group of the file.";
            };
            persist = lib.mkEnableOption "persist the file";
            cache = lib.mkEnableOption "cache the file";
            sync = {
              enable = lib.mkEnableOption "Syncthing handling of the file";
              rescan = lib.mkOption {
                type = lib.types.int;
                default = 60 * 60;
                defaultText = lib.literalExpression "60 * 60";
                example = lib.literalExpression "30 * 60";
                description = "The interval in seconds between Syncthing rescans.";
              };
              watch = {
                enable = lib.mkEnableOption "Sycnthing change watching" // {
                  default = true;
                };
                delay = lib.mkOption {
                  type = lib.types.int;
                  default = 10;
                  example = 30;
                  description = "The interval in seconds before Syncthing rescans when a change is detected.";
                };
              };
              order = lib.mkOption {
                type = lib.types.enum [
                  "random"
                  "alphabetic"
                  "smallestFirst"
                  "largestFirst"
                  "oldestFirst"
                  "newestFirst"
                ];
                default = "random";
                example = "newestFirst";
                description = "The order that Syncthing should pull files.";
              };
            };

            path = lib.mkOption {
              readOnly = true;
              default = if system then name else "${config'.home.homeDirectory}/${name}";
            };
          };
        }
      )
    );
    default = { };
    description = "Files to handle in the ${if system then "root" else "home"} filesystem.";
  };

  config =
    lib.setAttrByPath
      (
        [
          "systemd"
        ]
        ++ lib.optional (!system) "user"
        ++ [
          "tmpfiles"
          "rules"
        ]
      )
      (
        lib.flatten (
          (lib.mapAttrsToList (
            _: fCfg:
            let
              mkEntry = volume: "z \"${volume}${fCfg.path}\" ${fCfg.mode} ${fCfg.user} ${fCfg.group} - -";
            in
            [ (mkEntry "") ]
            ++ lib.optional (fCfg.dir && !fCfg.persist) (mkEntry "/persist")
            ++ lib.optional (fCfg.dir && !fCfg.cache) (mkEntry "/cache")
          ))
            cfg
        )
      );
}
