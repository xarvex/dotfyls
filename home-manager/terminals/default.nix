{ lib, ... }:

{
  imports = [
    ./wezterm.nix
  ];

  options.custom.terminal =
    let
      terminals = [ "wezterm" ];
    in
    {
      default = lib.mkOption {
        type = lib.types.enum terminals;
        example = "wezterm";
        description = "Default terminal to use.";
      };

      start = lib.mkOption {
        type = with lib.types; lazyAttrsOf str;
        default = { };
        example = lib.literalExpression ''
          {
            wezterm = lib.getExe pkgs.wezterm;
          };
        '';
        description = "Attribute set of terminals and commands to start.";
      };

      exec = lib.mkOption {
        type = with lib.types; lazyAttrsOf str;
        default = { };
        example = lib.literalExpression ''
          {
            wezterm = "$${lib.getExe pkgs.wezterm} start";
          };
        '';
        description = "Attribute set of terminals and commands to execute other programs.";
      };
    };
}
