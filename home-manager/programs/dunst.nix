{ config, lib, ... }:

{
  options.dotfyls.programs.dunst.enable = lib.mkEnableOption "Dunst" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.dunst.enable {
    services.dunst = {
      enable = true;
      # TODO: theme
    };
  };
}
