{ config, lib, ... }:

{
  options.dotfyls.shells.zsh.enable = lib.mkEnableOption "Zsh" // { default = true; };

  config = lib.mkIf config.dotfyls.shells.zsh.enable {
    programs.zsh = {
      enable = true;
      # TODO: init programs (fetch)
    };

    dotfyls.persist = {
      directories = [ ".local/state/zsh" ];
      cacheDirectories = [ ".cache/zsh" ];
    };
  };
}
