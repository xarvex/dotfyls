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

      shellInit = builtins.readFile ./shell-init.fish;
      interactiveShellInit = lib.mkBefore ''
        ${builtins.readFile ./interactive-shell-init.fish}

        ${cfg'.finalInitBins}
      '';
    };
  };
}
