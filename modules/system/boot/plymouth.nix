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
  options.dotfyls.boot.plymouth = {
    enable = lib.mkEnableOption "Plymouth" // {
      default = config.dotfyls.desktops.enable;
    };
    scale = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 2;
      description = "The scale of the Plymouth splash.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.boot.silent = lib.mkDefault true;

    boot = {
      kernelParams = [ "splash" ];

      plymouth = {
        enable = true;

        theme = "rings";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
        ];
        extraConfig = lib.optionalString (cfg.scale != null) ''
          DeviceScale=${toString cfg.scale}
        '';
      };
    };
  };
}
