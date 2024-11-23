{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.fastfetch;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "fastfetch"
      ]
      [
        "programs"
        "fastfetch"
      ]
    )
  ];

  options.dotfyls.programs.fastfetch.enable = lib.mkEnableOption "Fastfetch" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.shells.initBins = [ (self.lib.getCfgPkg cfg) ];

    home.shellAliases = rec {
      f = fetch;
      fetch = "fastfetch";

      neofetch = "fastfetch --config neofetch";
    };

    programs.fastfetch.enable = true;

    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
