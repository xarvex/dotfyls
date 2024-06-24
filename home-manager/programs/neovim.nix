{ config, lib, ... }:

{
  options.custom.programs.neovim.enable = lib.mkEnableOption "Enable Neovim (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    custom.persist.directories = [ ".local/share/nvim" ".local/state/nvim" ];
  };
}
