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

  config = lib.mkIf cfg.enable {
    dotfyls.files.persistDirectories = [ ".local/share/fish" ];

    programs.fish = {
      enable = true;

      shellInit = builtins.readFile ./shell-init.fish;
      interactiveShellInit = lib.mkBefore ''
        ${builtins.readFile ./interactive-shell-init.fish}

        ${cfg'.greet}
      '';
    };
  };
}
