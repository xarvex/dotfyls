{ config, lib, self, ... }:

let
  cfg = config.dotfyls.programs.fastfetch;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "programs" "fastfetch" ]
      [ "programs" "fastfetch" ])
  ];

  options.dotfyls.programs.fastfetch.enable = lib.mkEnableOption "Fastfetch" // { default = true; };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config.jsonc);
    };
  };
}
