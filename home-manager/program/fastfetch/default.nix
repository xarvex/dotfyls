{ config, lib, ... }:

{
  options.custom.program.fastfetch.enable = lib.mkEnableOption "Fastfetch" // { default = true; };

  config = lib.mkIf config.custom.program.fastfetch.enable {
    programs.fastfetch.enable = true;
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
