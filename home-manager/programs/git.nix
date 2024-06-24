{ config, lib, ... }:

{
  options.custom.programs.git.enable = lib.mkEnableOption "Enable Git (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.git.enable {
    programs.git = {
      enable = true;
    };

    custom.persist.directories = [ ".config/systemd" ]; # maintenance timers
  };
}
