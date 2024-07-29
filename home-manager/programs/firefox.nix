{ config, lib, ... }:

{
  options.dotfyls.programs.firefox.enable = lib.mkEnableOption "Firefox" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.firefox.enable {
    programs.firefox = {
      enable = true;
    };

    dotfyls.persist.directories = [ ".cache/mozilla" ".mozilla" ];
  };
}
