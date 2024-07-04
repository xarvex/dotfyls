{ config, lib, ... }:

{
  imports = [
    ./alacritty
    ./wezterm.nix
  ];

  options.dotfyls.terminal =
    let
      terminals = [
        "alacritty"
        "wezterm"
      ];
    in
    {
      default = lib.mkOption {
        type = lib.types.enum terminals;
        default = "wezterm";
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

  config.dotfyls.terminals.${config.dotfyls.terminal.default}.enable = lib.mkDefault true;
}
