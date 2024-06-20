{ config, lib, ... }:

{
  options.custom.program.neovim.enable = lib.mkEnableOption "Neovim" // { default = true; };

  config = lib.mkIf config.custom.program.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    custom.persist.directories = [ ".local/share/nvim" ".local/state/nvim" ];
  };
}
