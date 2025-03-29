{ config, lib, ... }:

{
  imports = [
    ./prismlauncher
    ./steam
    ./vintagestory

    ./r2modman.nix
  ];

  options.dotfyls.games.enable = lib.mkEnableOption "games" // {
    default = config.dotfyls.desktops.enable;
  };
}
