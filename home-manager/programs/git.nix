{ config, lib, ... }:

{
  options.custom.program.git.enable = lib.mkEnableOption "Git" // { default = true; };

  config = lib.mkIf config.custom.program.git.enable {
    programs.git = {
      enable = true;
    };

    custom.persist.directories = [ ".config/systemd" ]; # maintenance timers
  };
}
