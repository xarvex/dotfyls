{ config, lib, self, ... }:

let
  cfg = config.dotfyls.shells.shells.zsh;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [ "dotfyls" "shells" "shells" "zsh" ]
      [ "programs" "zsh" ])
  ];

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      # TODO: init programs (fetch)
    };

    dotfyls.persist = {
      directories = [ ".local/state/zsh" ];
      cacheDirectories = [ ".cache/zsh" ];
    };
  };
}
