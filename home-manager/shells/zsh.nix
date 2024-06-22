{ config, lib, ... }:

{
  options.custom.programs.zsh.enable = lib.mkEnableOption "Zsh" // { default = true; };

  config = lib.mkIf config.custom.programs.zsh.enable {
    programs.zsh = {
      enable = true;
    };

    custom.persist.files = [ ".local/state/zsh/history" ];
  };
}
