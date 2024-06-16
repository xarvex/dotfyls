{ config, lib, ... }:

let
  cfg = config.custom.terminal;
in
{
  options.custom.terminal = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "Terminal to use.";
    };

    start = lib.mkOption {
      type = lib.types.str;
      default = lib.getExe cfg.package;
      description = "Terminal command to start.";
    };

    exec = lib.mkOption {
      type = lib.types.str;
      default = lib.getExe cfg.package;
      description = "Terminal command to execute other programs.";
    };
  };
}
