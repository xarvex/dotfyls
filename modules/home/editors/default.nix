{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.editors;

  terminalEditors = {
    micro = "micro";
    neovim = "nvim";
  };
in
{
  imports = [
    ./neovim

    ./micro.nix
  ];

  options.dotfyls.editors = {
    enable = lib.mkEnableOption "editors" // {
      default = true;
    };
    default = lib.mkOption {
      type = lib.types.enum [
        "micro"
        "neovim"
      ];
      default = "neovim";
      example = "micro";
      description = "Default editor to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.editors = self.lib.enableSelected cfg.default [
      "micro"
      "neovim"
    ];

    home.sessionVariables = lib.mkIf (builtins.hasAttr cfg.default terminalEditors) (
      lib.genAttrs [
        "VISUAL"
        "EDITOR"
        "SUDO_EDITOR"
      ] (_: terminalEditors.${cfg.default})
    );
  };
}
