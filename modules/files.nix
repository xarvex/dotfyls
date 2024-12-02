system:
{ config, lib, ... }:

let
  cfg = config.dotfyls.files;
in
{
  options.dotfyls.files = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        let
          prependPath = lib.optionalString (!system) "${config.home.homeDirectory}/";
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
              description = "Mode of the file.";
            };
            persist = lib.mkEnableOption "persist the file";
            cache = lib.mkEnableOption "cache the file";

            path = lib.mkOption {
              internal = true;
              readOnly = true;
              default = prependPath + name;
            };
          };
        }
      )
    );
    default = { };
    description = "Files to handle in the ${if system then "root" else "home"} filesystem.";
  };

  config = lib.setAttrByPath (
    [
      "systemd"
    ]
    ++ lib.optional (!system) "user"
    ++ [
      "tmpfiles"
      "rules"
    ]
  ) ((lib.mapAttrsToList (_: fCfg: "z \"${fCfg.path}\" ${fCfg.mode} - - - -")) cfg);
}
