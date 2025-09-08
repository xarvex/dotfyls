{ config, lib, ... }:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.tldr;
in
{
  options.dotfyls.shells.tools.tldr.enable = lib.mkEnableOption "tldr" // {
    default = cfg'.enableUseful;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".cache/tealdeer".cache = true;

    programs.tealdeer = {
      enable = true;

      settings.style = {
        description.foreground = "magenta";
        command_name.foreground = "cyan";
        example_text.foreground = "green";
        example_code.foreground = "cyan";
        example_variable = {
          foreground = "red";
          italic = true;
        };
      };
    };
  };
}
