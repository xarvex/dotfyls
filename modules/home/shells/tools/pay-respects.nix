{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.pay-respects;

  tomlFormat = pkgs.formats.toml { };
in
{
  options.dotfyls.shells.tools.pay-respects.enable = lib.mkEnableOption "Pay Respects" // {
    default = cfg'.enableFun || cfg'.enableUseful;
  };

  config = lib.mkIf cfg.enable {
    programs.pay-respects.enable = true;

    xdg.configFile."pay-respects/config.toml".source = tomlFormat.generate "pay-respects-config" {
      package_manager = {
        package_manager = "nix";
        install_method = "Shell";
      };
    };
  };
}
