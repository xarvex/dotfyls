system:
{
  lib,
  osConfig ? null,
  ...
}:

let
  osCfg = if (system || osConfig == null) then null else osConfig.dotfyls.filesystems.drives;

  sanitize =
    string:
    builtins.replaceStrings [ "_" ] [ "-" ] (lib.strings.sanitizeDerivationName (lib.toLower string));
in
{
  options.dotfyls.filesystems.drives = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, name, ... }:
        {
          options = {
            enable = lib.mkEnableOption config.name // {
              readOnly = osCfg != null;
              default = osCfg != null && osCfg.${name}.enable;
            };

            id = lib.mkOption {
              readOnly = true;
              type = lib.types.str;
              default = name;
              defaultText = lib.literalExpression "name";
              description = "The id used to refer to the drive.";
            };

            name = lib.mkOption {
              readOnly = osCfg != null;
              type = lib.types.str;
              description = "The friendly name of the drive.";
            };
            label = lib.mkOption {
              readOnly = osCfg != null;
              type = lib.types.str;
              default = sanitize name;
              defaultText = lib.literalExpression "sanitize name";
              description = "The label of the drive.";
            };
            mountpoint = lib.mkOption {
              readOnly = osCfg != null;
              type = lib.types.str;
              default = "/media/${sanitize name}";
              defaultText = lib.literalExpression "/media/\${sanitize name}";
              description = "The mountpoint of the drive.";
            };
          };
        }
      )
    );
  };

  config.dotfyls.filesystems.drives = lib.mapAttrs' (
    name: cfg: lib.nameValuePair (sanitize name) ({ inherit name; } // cfg)
  ) { "1TB Samsung PSSD T9".label = "1tb-pssd-t9"; };
}
