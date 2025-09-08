{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.management.image;
in
{
  options.dotfyls.management.image = {
    enable = lib.mkEnableOption "imaging" // {
      default = config.dotfyls.desktops.enable;
    };

    supportRPI = lib.mkEnableOption "Raspberry Pi Imager";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          (ventoy-full.overrideAttrs (o: {
            meta = o.meta // {
              knownVulnerabilities = [ ];
              license = o.meta.license // {
                free = true;
              };
            };
          }))
        ];
      }

      (lib.mkIf cfg.supportRPI {
        dotfyls.file.".cache/Raspberry Pi/Imager".cache = true;

        home.packages = with pkgs; [ rpi-imager ];
      })
    ]
  );
}
