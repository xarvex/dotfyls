{ config, lib, ... }:

{
  options.custom.shells.zsh.enable = lib.mkEnableOption "Enable Zsh (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.shells.zsh.enable {
    programs.zsh = {
      enable = true;
    };

    custom.persist.files = [ ".local/state/zsh/history" ];
  };
}
