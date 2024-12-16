{ config, lib, ... }:

{
  imports = [
    ./prismlauncher
    ./steam
    ./vintagestory
  ];

  options.dotfyls.games.enable = lib.mkEnableOption "games" // {
    default = config.dotfyls.desktops.enable;
  };
}
