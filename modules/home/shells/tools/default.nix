{ config, lib, ... }:

{
  imports = [
    ./fastfetch

    ./bat.nix
    ./cbonsai.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./pay-respects.nix
    ./ripgrep.nix
    ./sl.nix
    ./starship.nix
    ./tldr.nix
    ./tokei.nix
    ./zoxide.nix
  ];

  options.dotfyls.shells.tools = {
    enableFun = lib.mkEnableOption "fun shell tools" // {
      default = config.dotfyls.terminals.enable;
    };
    enableUseful = lib.mkEnableOption "useful shell tools" // {
      default = true;
    };
    enableUtility = lib.mkEnableOption "utility shell tools" // {
      default = true;
    };
  };
}
