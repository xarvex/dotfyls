{ lib, ... }:

{
  imports = [
    ./wezterm.nix
  ];

  options.custom.terminal = {
    default = lib.mkOption {
      type = lib.types.str;
      description = "Terminal to use";
    };

    start = lib.mkOption {
      type = with lib.types; lazyAttrsOf str;
      default = { };
      description = "Attribute set of terminals and commands to start";
    };

    exec = lib.mkOption {
      type = with lib.types; lazyAttrsOf str;
      default = { };
      description = "Attribute set of terminals and commands to execute other programs";
    };
  };
}
