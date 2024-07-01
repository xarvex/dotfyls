{ config, lib, ... }:

{
  options.custom.programs.firefox.enable = lib.mkEnableOption "Firefox" // { default = true; };

  config = lib.mkIf config.custom.programs.firefox.enable {
    programs.firefox = {
      enable = true;
      # TODO: configure
    };

    custom.persist.directories = [ ".cache/mozilla" ".mozilla" ];
  };
}
