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
    dotfyls.file.".local/share/fish" = {
      mode = "0700";
      persist = true;
    };

    programs.fish = {
      enable = true;

      shellInit = lib.mkAfter ''
        function fish_greeting
        ${builtins.concatStringsSep "\n" (map (line: "    ${line}") (lib.splitString "\n" cfg'.greet))}
        end
      '';
      interactiveShellInit = lib.mkBefore (builtins.readFile ./interactive-shell-init.fish);
    };
  };
}
