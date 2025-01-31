{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.security.yubikey;
  cfg = config.dotfyls.security.yubikey.yubioath;
in
{
  options.dotfyls.security.yubikey.yubioath.enable = lib.mkEnableOption "Yubico Authenticator" // {
    default = config.dotfyls.desktops.enable;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) { home.packages = with pkgs; [ yubioath-flutter ]; };
}
