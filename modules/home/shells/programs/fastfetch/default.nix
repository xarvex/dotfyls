{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.fastfetch;
in
{
  options.dotfyls.shells.programs.fastfetch.enable = lib.mkEnableOption "Fastfetch" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.shells.greet = self.lib.getCfgExe config.programs.fastfetch;

    home.shellAliases = rec {
      f = fetch;
      fetch = "fastfetch";

      neofetch = "fastfetch --config neofetch";
    };

    programs.fastfetch.enable = true;

    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
