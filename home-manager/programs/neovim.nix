{ config, lib, ... }:

{
  options.dotfyls.programs.neovim.enable = lib.mkEnableOption "Neovim" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    dotfyls.persist.directories = [ ".local/share/nvim" ".local/state/nvim" ];
  };
}
