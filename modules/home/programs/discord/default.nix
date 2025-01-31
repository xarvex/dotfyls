{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.programs.discord;
in
{
  options.dotfyls.programs.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf cfg.enable {
    dotfyls.file.".config/discord" = {
      mode = "0700";
      cache = true;
    };

    home.packages = with pkgs; [ discord ];
  };
}
