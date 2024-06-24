{ config, lib, ... }:

{
  options.custom.programs.fastfetch.enable = lib.mkEnableOption "Enable Fastfetch (home-manager)" // { default = true; };

  config = lib.mkIf config.custom.programs.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config.jsonc);
    };
  };
}
