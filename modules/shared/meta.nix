system:
{
  config,
  lib,
  osConfig ? null,
  ...
}:

let
  cfg = config.dotfyls.meta;
  hmCfg = config.hm.dotfyls.meta;
  osCfg = if (system || osConfig == null) then null else osConfig.dotfyls.meta;

  mkOption = attrs: lib.mkOption ({ readOnly = osCfg != null; } // attrs);
in
{
  options.dotfyls.meta = {
    id =
      mkOption {
        type = lib.types.str;
        description = ''
          Unique, 32-bit hexadecimal ID.

          Derive from generated machine-id:

          ```sh
          head -c 8 /etc/machine-id
          ```

          Random machine-id:

          ```sh
          head -c4 /dev/urandom | od -A none -t x4
          ```
        '';
      }
      // lib.optionalAttrs (osCfg != null) { default = osCfg.id; };
    name =
      mkOption {
        type = lib.types.str;
        description = "Preferably, the unique name.";
      }
      // lib.optionalAttrs (osCfg != null) { default = osCfg.name; };

    user =
      mkOption {
        type = lib.types.str;
        example = "admin";
        description = "The main, administrative user.";
      }
      // (lib.optionalAttrs (system || osCfg != null) {
        default = if system then "xarvex" else osCfg.user;
      });
    group =
      mkOption {
        type = lib.types.str;
        example = "admin";
        description = "Group of the main, administrative user.";
      }
      // (lib.optionalAttrs (system || osCfg != null) {
        default = if system then "users" else osCfg.group;
      });
    home =
      mkOption {
        type = lib.types.str;
        example = "/home/whatever";
        default = "/home/${cfg.user}";
        defaultText = lib.literalExpression ''"/home/''${config.dotfyls.meta.user}"'';
        description = "Home for the main, administrative user.";
      }
      // (lib.optionalAttrs (osCfg != null) { default = osCfg.home; });

    location = lib.mkOption {
      readOnly = system && hmCfg != null;
      type = with lib.types; nullOr str;
      default = if system && hmCfg != null then hmCfg.location else null;
      description = "The location of the configuration.";
    };

    machine =
      let
        mkIsOption =
          type: thing:
          mkOption {
            type = lib.types.bool;
            default = cfg.machine.type == type;
            defaultText = lib.literalExpression ''config.dotfyls.meta.machine.type == "${type}"'';
            description = "Whether the machine is ${thing}.";
          };
        mkIsAOption = type: mkIsOption type "a ${type}" // { readOnly = true; };
      in
      {
        type =
          mkOption {
            type = lib.types.enum [
              "desktop"
              "laptop"
              "server"
              "virtual"
            ];
            example = "laptop";
            description = "The type of machine being configured.";
          }
          // lib.optionalAttrs (osCfg != null) { default = osCfg.machine.type; };
        remote = mkIsOption "server" "remote";
        battery = mkIsOption "laptop" "battery-powered";

        isDesktop = mkIsAOption "desktop";
        isLaptop = mkIsAOption "laptop";
        isServer = mkIsAOption "server";
        isVirtual = mkIsAOption "virtual";
      };

    hardware = {
      threads =
        mkOption {
          type = lib.types.int;
          example = 16;
          description = "Number of hardware threads.";
        }
        // lib.optionalAttrs (osCfg != null) { default = osCfg.hardware.threads; };
      memory =
        mkOption {
          type = lib.types.int;
          example = lib.literalExpression "32 * 1000";
          description = "Amount of memory (RAM) in bytes.";
        }
        // lib.optionalAttrs (osCfg != null) { default = osCfg.hardware.memory; };
    };
  };
}
