{ config, lib, ... }:

{
  imports = [
    ./alacritty
    ./kitty.nix
    ./wezterm.nix
  ];

  options.dotfyls =
    let
      terminals = [
        "alacritty"
        "kitty"
        "wezterm"
      ];
    in
    {
      defaultTerminal = lib.mkOption {
        type = lib.types.enum terminals;
        default = "wezterm";
        example = "kitty";
        description = "Default terminal to use.";
      };

      terminals = {
        start = lib.mkOption {
          type = with lib.types; lazyAttrsOf str;
          default = { };
          example = lib.literalExpression ''
            {
              alacritty = lib.getExe pkgs.alacritty;
              kitty = lib.getExe pkgs.kitty;
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
              kitty = lib.getExe pkgs.kitty;
              wezterm = "$${lib.getExe pkgs.wezterm} start";
            };
          '';
          description = "Attribute set of terminals and commands to execute other programs.";
        };
      };
    };

  config.dotfyls.terminals.${config.dotfyls.defaultTerminal}.enable = lib.mkDefault true;
}
