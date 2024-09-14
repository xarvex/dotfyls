{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.shells.shells.zsh;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "shells"
        "shells"
        "zsh"
      ]
      [
        "programs"
        "zsh"
      ]
    )
  ];

  options.dotfyls.shells.shells.zsh.enable = lib.mkEnableOption "Zsh";

  config = lib.mkIf cfg.enable {
    dotfyls.persist = {
      directories = [ ".local/state/zsh" ];
      cacheDirectories = [ ".cache/zsh" ];
    };

    programs.zsh = {
      enable = true;
      dotfyls = {
        inherit (config.dotfyls.shells) historySize;

        enable = true;
      };

      initExtraFirst = lib.mkBefore config.dotfyls.shells.finalInitBins;
    };
  };
}
