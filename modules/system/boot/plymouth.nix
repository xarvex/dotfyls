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
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.boot.silent = lib.mkDefault true;

    boot = {
      kernelParams = [
        "splash"
        "plymouth.use-simpledrm"
      ];

      plymouth = {
        enable = true;

        theme = "rings";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
        ];
      };
    };
  };
}
