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
    dotfyls.shells.initBins = with cfg; [ package ];

    home.shellAliases = {
      neofetch = "fastfetch --config neofetch";
      fetch = "fastfetch";
    };

    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config.jsonc);
    };
  };
}
