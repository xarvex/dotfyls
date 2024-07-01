{ config, lib, ... }:

{
  options.dotfyls.programs.git.enable = lib.mkEnableOption "Git" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.git.enable {
    programs.git = {
      enable = true;
    };

    dotfyls.persist.directories = [ ".config/systemd" ]; # maintenance timers
  };
}
