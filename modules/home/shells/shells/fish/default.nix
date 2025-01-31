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
  options.dotfyls.shells.shells.fish = {
    enable = lib.mkEnableOption "Fish";
    package = self.lib.mkStaticPackageOption (self.lib.getCfgPkg config.programs.fish);
  };

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
