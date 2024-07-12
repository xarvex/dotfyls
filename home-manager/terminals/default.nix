{ config, lib, ... }:

{
  imports = [
    ./alacritty
    ./wezterm.nix
  ];

  options.dotfyls =
    let
      terminals = [
        "alacritty"
        "wezterm"
      ];
    in
    {
      defaultTerminal = lib.mkOption {
        type = lib.types.enum terminals;
        default = "wezterm";
        example = "wezterm";
        description = "Default terminal to use.";
      };

      terminals = {
        start = lib.mkOption {
          type = with lib.types; lazyAttrsOf str;
          default = { };
          example = lib.literalExpression ''
            {
              alacritty = lib.getExe pkgs.alacritty;
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
              alacritty = "$${lib.getExe pkgs.alacritty} -e";
              wezterm = "$${lib.getExe pkgs.wezterm} start";
            };
          '';
          description = "Attribute set of terminals and commands to execute other programs.";
        };
      };
    };

  config.dotfyls.terminals.${config.dotfyls.defaultTerminal}.enable = lib.mkDefault true;
}
