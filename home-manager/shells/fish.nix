{
  config,
  lib,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.shells.fish;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "shells"
        "shells"
        "fish"
      ]
      [
        "programs"
        "fish"
      ]
    )
  ];

  options.dotfyls.shells.shells.fish.enable = lib.mkEnableOption "Fish";

  config = lib.mkIf cfg.enable {
    dotfyls.persist.directories = [ ".local/share/fish" ];

    programs.fish = {
      enable = true;

      shellInit = ''
        set fish_greeting
      '';
      interactiveShellInit = lib.mkBefore ''
        for alias in (alias)
          set alias (string split --no-empty ' ' -- $alias)
          set -e alias[1]
          functions -e $alias[1]
          if test $alias[1] != ..
            eval abbr -a -- $alias
          end
        end

        fish_vi_key_bindings

        ${cfg'.finalInitBins}
      '';
    };
  };
}
