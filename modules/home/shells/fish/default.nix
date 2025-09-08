{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.fish;
in
{
  options.dotfyls.shells.fish.enable = lib.mkEnableOption "Fish";

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".local/share/fish" = {
        mode = "0700";
        persist = true;
      };

      ".cache/fish".mode = "0700";
      ".cache/fish/generated_completions".cache = true;
    };

    programs.fish = {
      enable = true;

      shellInit = lib.mkAfter ''
        function fish_greeting
        ${lib.concatMapStringsSep "\n" (line: "    ${line}") (lib.splitString "\n" cfg'.greet)}
        end
      '';
      interactiveShellInit = lib.mkBefore (builtins.readFile ./interactive-shell-init.fish);
    };
  };
}
