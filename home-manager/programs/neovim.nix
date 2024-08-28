{ config, lib, self, ... }:

let
  cfg = config.dotfyls.programs.neovim;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "neovim" ]
      [ "programs" "neovim" ])
  ];

  options.dotfyls.programs.neovim.enable = lib.mkEnableOption "Neovim" // { default = true; };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/share/nvim" ".local/state/nvim" ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
