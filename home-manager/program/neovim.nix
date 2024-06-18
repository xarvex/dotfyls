{ config, inputs, lib, pkgs, ... }:

let
  nvim = inputs.neovim.specialArgs.${pkgs.system}.default;
in
{
  options.custom.program.neovim.enable = lib.mkEnableOption "Neovim" // { default = true; };

  config = lib.mkIf config.custom.program.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      package = nvim.package;
      extraPackages = nvim.extraPackages;
    };

    xdg.configFile.nvim = {
      recursive = true;
      source = nvim.self;
    };

    custom.persist.directories = [
      ".config/nvim"
      ".local/share/nvim"
      ".local/state/nvim"
    ];
  };
}
