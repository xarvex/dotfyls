{ config, lib, ... }:

{
  options.custom.programs.dunst.enable = lib.mkEnableOption "Dunst" // { default = true; };

  config = lib.mkIf config.custom.programs.dunst.enable {
    services.dunst = {
      enable = true;
      # TODO: theme
    };
  };
}
