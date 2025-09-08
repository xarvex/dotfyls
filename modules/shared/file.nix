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
              defaultText = lib.literalExpression ''if config.dir then "0755" else "0644"'';
              example = lib.literalExpression ''if config.dir then "0700" else "0600"'';
              description = "Mode of the file.";
            };
            user = lib.mkOption {
              type = lib.types.str;
              default = if system then "root" else config'.home.username;
              defaultText = if system then "root" else (lib.literalExpression "config.home.username");
              example = lib.literalExpression "config.dotfyls.meta.user";
              description = "User of the file.";
            };
            group = lib.mkOption {
              type = lib.types.str;
              default =
                if config.user == config'.dotfyls.meta.user then config'.dotfyls.meta.group else config.user;
              defaultText = lib.literalExpression "if cfg.user == config.dotfyls.meta.user then config.dotfyls.meta.group else cfg.user";
              example = lib.literalExpression "config.dotfyls.meta.group";
              description = "Group of the file.";
            };
            persist = lib.mkEnableOption "persist the file";
            cache = lib.mkEnableOption "cache the file";

            path = lib.mkOption {
              readOnly = true;
              default = if system then name else "${config'.home.homeDirectory}/${name}";
            };
          }
          // lib.optionalAttrs (!system) {
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
                enable = lib.mkEnableOption "Syncthing change watching" // {
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
          };
        }
      )
    );
    default = { };
    description = "Files to handle in the ${if system then "root" else "home"} filesystem.";
  };

  config =
    let
      mkTmpFile' =
        if system then
          fCfg: volume: lib.nameValuePair "${volume}${fCfg.path}" { z = { inherit (fCfg) mode user group; }; }
        else
          fCfg: volume: "z '${volume}${fCfg.path}' '${fCfg.mode}' '${fCfg.user}' '${fCfg.group}' - -";
      tmpFiles = lib.flatten (
        lib.mapAttrsToList (
          _: fCfg:
          let
            mkTmpFile = mkTmpFile' fCfg;
          in
          [ (mkTmpFile "") ]
          ++ lib.optionals config.dotfyls.filesystems.impermanence.enable (
            lib.optional (!fCfg.persist) (mkTmpFile "/persist")
            ++ lib.optional (!fCfg.cache) (mkTmpFile "/cache")
          )
        ) cfg
      );
    in
    if system then
      { systemd.tmpfiles.settings.dotfyls-file = builtins.listToAttrs tmpFiles; }
    else
      { systemd.user.tmpfiles.rules = tmpFiles; };
}
