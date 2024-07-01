{ config, lib, ... }:

{
  options.dotfyls.programs.fastfetch.enable = lib.mkEnableOption "Fastfetch" // { default = true; };

  config = lib.mkIf config.dotfyls.programs.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config.jsonc);
    };
  };
}
