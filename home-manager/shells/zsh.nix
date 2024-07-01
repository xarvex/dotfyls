{ config, lib, ... }:

{
  options.dotfyls.shells.zsh.enable = lib.mkEnableOption "Zsh" // { default = true; };

  config = lib.mkIf config.dotfyls.shells.zsh.enable {
    programs.zsh = {
      enable = true;
    };

    dotfyls.persist.files = [ ".local/state/zsh/history" ];
  };
}
