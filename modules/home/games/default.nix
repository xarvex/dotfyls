{ config, lib, ... }:

{
  imports = [
    ./prismlauncher.nix
    ./steam.nix
    ./vintagestory.nix
    ./r2modman.nix
  ];

  options.dotfyls.games.enable = lib.mkEnableOption "games" // {
    default = config.dotfyls.desktops.enable;
  };
}
