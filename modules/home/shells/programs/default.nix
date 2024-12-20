{ config, lib, ... }:

{
  imports = [
    ./bat
    ./cbonsai
    ./eza
    ./fastfetch
    ./fd
    ./fzf
    ./ripgrep
    ./sl
    ./starship
    ./thefuck
    ./tldr
    ./zoxide
  ];

  options.dotfyls.shells.programs = {
    enableFun = lib.mkEnableOption "fun shell programs" // {
      default = config.dotfyls.terminals.enable;
    };
    enableUseful = lib.mkEnableOption "useful shell programs" // {
      default = true;
    };
    enableUtility = lib.mkEnableOption "utility shell programs" // {
      default = true;
    };
  };
}
