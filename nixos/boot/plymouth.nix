{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.boot.plymouth;
in
{
  options.dotfyls.boot.plymouth.enable = lib.mkEnableOption "Plymouth" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.boot.silent = lib.mkDefault true;

    boot.plymouth = {
      enable = true;

      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
      ];
    };
  };
}